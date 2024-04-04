unit udmconexao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, DB, BufDataset;

type

  { TDM }

  TTpConexao = (tpFB);

  TDM = class(TDataModule)
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ZConnectionBeforeConnect(Sender: TObject);
  private
    FTpConexao: TTpConexao;
    procedure SetTpConexao(AValue: TTpConexao);
  public
    function isExist(aID: Integer): Boolean;
    function GetPessoa(aID: Integer): string;
    function SavePessoa(aID: Integer; aJson: string): string;
    function SavePessoaDetails(aID: Integer; aJson: string): string;
    function DeletePessoa(aID: Integer): string;
    function GetPessoaStructure: string;
    function GetDetailStructure(aTpPessoa: Integer): string;
    function GetLastID: Integer;
    function GetTpPessoa(aID: Integer): Integer;
    property TpConexao: TTpConexao read FTpConexao write SetTpConexao;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

uses
  dc4dl, j4dl;

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FTpConexao := tpFB;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  ZQuery.Close;
  ZConnection.Connected := False;
end;

procedure TDM.ZConnectionBeforeConnect(Sender: TObject);
begin
  ZConnection.Database := 'C:\Users\User\Desktop\Repositórios\AppPedidos\Database\APPORDERS.FDB';
  ZConnection.Protocol := 'firebird';
  ZConnection.Port := 3050;
  ZConnection.User := 'SYSDBA';
  ZConnection.Password := 'masterkey';

  {$IFDEF WIN32}
  ZConnection.LibLocation := '';
  {$ELSE}
  ZConnection.LibLocation := '';
  {$ENDIF}
end;

procedure TDM.SetTpConexao(AValue: TTpConexao);
begin
  if FTpConexao = AValue then Exit;
  FTpConexao := AValue;
end;

function TDM.isExist(aID: Integer): Boolean;
var
  lQuery: TZQuery;
begin
  Result := False;

  lQuery := TZQuery.Create(nil);
  try
    lQuery.Connection := ZConnection;
    lQuery.SQL.Add(' SELECT id FROM pessoa ');
    lQuery.SQL.Add(' WHERE id = :id ');
    lQuery.Params[0].AsInteger := aID;
    try
      lQuery.Open;
      Result := not lQuery.IsEmpty;
    except
      on E: exception do
         Raise Exception.Create(E.Message);
    end;

  finally
    lQuery.Close;
    FreeAndNil(lQuery);
  end;
end;

function TDM.GetPessoa(aID: Integer): string;
var
  lJson: TJsonObject;
  lTpPessoa: Integer;
begin
  lJson := TJsonObject.Create();
  try
    try
      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add(' SELECT * FROM pessoa ');

      if (aID > -1) then
      begin

        lTpPessoa := GetTpPessoa(aID);
        case lTpPessoa of
          0: begin
            ZQuery.SQL.Add(' LEFT JOIN cliente ON pessoa.id = cliente.id ');
          end;
          1: begin
            ZQuery.SQL.Add(' LEFT JOIN funcionario ON pessoa.id = funcionario.id ');
          end;
          2: begin
            ZQuery.SQL.Add(' LEFT JOIN fornecedor ON pessoa.id = fornecedor.id ');
          end;
        end;

        ZQuery.SQL.Add(' WHERE pessoa.id = :id ');
        ZQuery.Params[0].AsInteger := aID;
      end
      else
      begin
        ZQuery.SQL.Add(' WHERE pessoa.id > 0 ');
      end;

      ZQuery.SQL.Add(' ORDER BY pessoa.id ');
      ZQuery.Open;
      // Configura a query que buscará os dados no banco

      lJson.Put('success', True);
      lJson.Put('message', Format('Total de Registros: %d', [ZQuery.RecordCount]));
      lJson.Put('tipo_operacao', -1);
      lJson.Put('structure', TConverter.New.LoadDataSet(ZQuery).ToJSONStructure);
      lJson.Put('data', TConverter.New.LoadDataSet(ZQuery).ToJSONArray);
      // Monta o json
    except
      on E: exception do
      begin
        lJson.Put('success', False);
        lJson.Put('message', E.Message);
      end;
    end;
  finally
    Result := lJson.Stringify;
    FreeAndNil(lJson);
    // Transforma o json em uma string, retorna e libera a instância de TJsonObject
  end;
end;

function TDM.SavePessoa(aID: Integer; aJson: string): string;
var
  lQuery: TZQuery;
  lJsonTmp,
  lJson: TJsonObject;
  lIsExist: Boolean;
  lMsg: string;
begin
  lMsg := '';
  lQuery := TZQuery.Create(nil);
  try
    lQuery.Connection := ZConnection;
    lJson := TJsonObject.Create();

    if not ZConnection.Connected then
      ZConnection.Connected := True;
    if not ZConnection.InTransaction then
      ZConnection.StartTransaction;

    try
      if lJson.IsJsonObject(aJson) then
      begin
        lJson.Parse(aJson);

        lIsExist := IsExist(aID);

        if not lIsExist then
        begin
          lQuery.SQL.Add(' INSERT INTO pessoa                                                  ');
          lQuery.SQL.Add(' (nome_razao, apelido_fantasia, cpf_cnpj,                            ');
          lQuery.SQL.Add(' logradouro, numero, bairro, cep, municipio, uf, tipo_pessoa)        ');
          lQuery.SQL.Add(' VALUES                                                              ');
          lQuery.SQL.Add(' (:nome_razao, :apelido_fantasia, :cpf_cnpj,                         ');
          lQuery.SQL.Add(' :logradouro, :numero, :bairro, :cep, :municipio, :uf, :tipo_pessoa) ');
          lQuery.SQL.Add(' RETURNING id                                                        ');

          lQuery.ParamByName('tipo_pessoa').AsInteger       := lJson.Values['tipo_pessoa'].AsInteger;
        end
        else
        begin
          lQuery.SQL.Add(' UPDATE pessoa                                                                                              ');
          lQuery.SQL.Add(' SET nome_razao = :nome_razao, apelido_fantasia = :apelido_fantasia, cpf_cnpj = :cpf_cnpj,                  ');
          lQuery.SQL.Add(' logradouro = :logradouro, numero = :numero, bairro = :bairro, cep = :cep, municipio = :municipio, uf = :uf');
          lQuery.SQL.Add(' WHERE id = :id                                                                                             ');

          lQuery.ParamByName('id').AsInteger := aID;
        end;


        lQuery.ParamByName('nome_razao').AsString         := lJson.Values['nome_razao'].AsString;
        lQuery.ParamByName('apelido_fantasia').AsString   := lJson.Values['apelido_fantasia'].AsString;
        lQuery.ParamByName('cpf_cnpj').AsString           := lJson.Values['cpf_cnpj'].AsString;
        lQuery.ParamByName('logradouro').AsString         := lJson.Values['logradouro'].AsString;
        lQuery.ParamByName('numero').AsString             := lJson.Values['numero'].AsString;
        lQuery.ParamByName('bairro').AsString             := lJson.Values['bairro'].AsString;
        lQuery.ParamByName('cep').AsString                := lJson.Values['cep'].AsString;
        lQuery.ParamByName('municipio').AsString          := lJson.Values['municipio'].AsString;
        lQuery.ParamByName('uf').AsString                 := lJson.Values['uf'].AsString;


        try
          if not lIsExist then
          begin
            lQuery.Open;
            aID := lQuery.Fields[0].AsInteger;
            lMsg := 'Incluído com sucesso!';
          end
          else
          begin
            lQuery.ExecSQL;
            lMsg := 'Alterado com sucesso!';
          end;

          lJson.Clear;
          lJson.Put('success', true);
          lJson.Put('message', lMsg);

          lJsonTmp := TJsonObject.Create();
          try
            lJsonTmp.Parse( GetPessoa(aID) );

            if lJsonTmp.Values['success'].AsBoolean then
              lJson.Put('data', lJsonTmp.Values['data'].AsArray[0].AsObject );

            if ZConnection.InTransaction then
              ZConnection.Commit;

          finally
            FreeAndNil(lJsonTmp);
          end;

        except
          on E: exception do
             Raise Exception.Create(E.Message);
        end;
      end
      else
      begin
        lJson.Clear;
        lJson.Put('success', False);
        lJson.Put('message', 'Invalid JSON');
      end;

    finally
      Result := lJson.Stringify;
      FreeAndNil(lJson)
    end;
  finally
    FreeAndNil(lQuery);
  end;
end;

function TDM.SavePessoaDetails(aID: Integer; aJson: string): string;
var
  lJsonReq: TJSONObject;
  lQuery: TZQuery;
  tpOperacao,
  lID,
  lTpPessoa: Integer;
  lMsg: String;
begin
  lJsonReq := TJSONObject.Create(nil);
  lQuery := TZQuery.Create(nil);
  lQuery.Connection := ZConnection;
  try
    try

      if not lJsonReq.IsJsonObject(aJson) then
        Raise Exception.Create('JSON Inválido!');

      lJsonReq.Parse(aJson);

      lID := lJsonReq.Values['id'].AsInteger;

      lTpPessoa := lJsonReq.Values['tipo_pessoa'].AsInteger;
      tpOperacao := lJsonReq.Values['tipo_operacao'].AsInteger;

      case tpOperacao of
        0:
        begin
          case lTpPessoa of
            0:
            begin
              lQuery.SQL.Add(' INSERT INTO cliente                                                     ');
              lQuery.SQL.Add(' (id, limite_credito, telefone_fixo, telefone_celular, email, obs)       ');
              lQuery.SQL.Add(' VALUES                                                                  ');
              lQuery.SQL.Add(' (:id, :limite_credito, :telefone_fixo, :telefone_celular, :email, :obs) ');

              lQuery.ParamByName('id').AsInteger                 := lID;
              lQuery.ParamByName('limite_credito').AsInteger     := lJsonReq.Values['limite_credito'].AsInteger;
              lQuery.ParamByName('telefone_fixo').AsString       := lJsonReq.Values['telefone_fixo'].AsString;
              lQuery.ParamByName('telefone_celular').AsString    := lJsonReq.Values['telefone_celular'].AsString;
              lQuery.ParamByName('email').AsString               := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('obs').AsString                 := lJsonReq.Values['obs'].AsString;
            end;
            1:
            begin
              lQuery.SQL.Add(' INSERT INTO funcionario                           ');
              lQuery.SQL.Add(' (id, comissao, email, login, senha, master)       ');
              lQuery.SQL.Add(' VALUES                                            ');
              lQuery.SQL.Add(' (:id, :comissao, :email, :login, :senha, :master) ');

              lQuery.ParamByName('id').AsInteger         := lID;
              lQuery.ParamByName('comissao').AsInteger   := lJsonReq.Values['comissao'].AsInteger;
              lQuery.ParamByName('email').AsString       := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('login').AsString       := lJsonReq.Values['login'].AsString;
              lQuery.ParamByName('senha').AsString       := lJsonReq.Values['senha'].AsString;
              lQuery.ParamByName('master').AsInteger     := lJsonReq.Values['master'].AsInteger;
            end;
            2:
            begin
              lQuery.SQL.Add(' INSERT INTO fornecedor                   ');
              lQuery.SQL.Add(' (id, telefone, email, website, obs)      ');
              lQuery.SQL.Add(' VALUES                                   ');
              lQuery.SQL.Add(' (:id, :telefone, :email, :website, :obs) ');

              lQuery.ParamByName('id').AsInteger         := lID;
              lQuery.ParamByName('telefone').AsString    := lJsonReq.Values['telefone'].AsString;
              lQuery.ParamByName('email').AsString       := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('website').AsString     := lJsonReq.Values['website'].AsString;
              lQuery.ParamByName('obs').AsString         := lJsonReq.Values['obs'].AsString;
            end;
          end;
        end;
        1:
        begin
          case lTpPessoa of
            0:
            begin
              lQuery.SQL.Add(' UPDATE cliente SET                                                ');
              lQuery.SQL.Add(' limite_credito = :limite_credito, telefone_fixo = :telefone_fixo, ');
              lQuery.SQL.Add(' telefone_celular = :telefone_celular, email = :email, obs = :obs  ');
              lQuery.SQL.Add(' WHERE id = :id                                                    ');

              lQuery.ParamByName('id').AsInteger                 := lID;
              lQuery.ParamByName('limite_credito').AsInteger     := lJsonReq.Values['limite_credito'].AsInteger;
              lQuery.ParamByName('telefone_fixo').AsString       := lJsonReq.Values['telefone_fixo'].AsString;
              lQuery.ParamByName('telefone_celular').AsString    := lJsonReq.Values['telefone_celular'].AsString;
              lQuery.ParamByName('email').AsString               := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('obs').AsString                 := lJsonReq.Values['obs'].AsString;
            end;
            1:
            begin
              lQuery.SQL.Add(' UPDATE funcionario SET                                                                 ');
              lQuery.SQL.Add(' comissao = :comissao, email = :email, login = :login, senha = :senha, master = :master ');
              lQuery.SQL.Add(' WHERE id = :id                                                                         ');

              lQuery.ParamByName('id').AsInteger         := lID;
              lQuery.ParamByName('comissao').AsInteger   := lJsonReq.Values['comissao'].AsInteger;
              lQuery.ParamByName('email').AsString       := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('login').AsString       := lJsonReq.Values['login'].AsString;
              lQuery.ParamByName('senha').AsString       := lJsonReq.Values['senha'].AsString;
              lQuery.ParamByName('master').AsInteger     := lJsonReq.Values['master'].AsInteger;
            end;
            2:
            begin
              lQuery.SQL.Add(' UPDATE fornecedor SET                                                ');
              lQuery.SQL.Add(' telefone = :telefone, email = :email, website = :website, obs = :obs ');
              lQuery.SQL.Add(' WHERE id = :id                                                       ');

              lQuery.ParamByName('id').AsInteger         := lID;
              lQuery.ParamByName('telefone').AsString    := lJsonReq.Values['telefone'].AsString;
              lQuery.ParamByName('email').AsString       := lJsonReq.Values['email'].AsString;
              lQuery.ParamByName('website').AsString     := lJsonReq.Values['website'].AsString;
              lQuery.ParamByName('obs').AsString         := lJsonReq.Values['obs'].AsString;
            end;
          end;
        end;
      end;

      case tpOperacao of
        0:
        begin
          lQuery.ExecSQL;
          lMsg := 'INCLUÍDO com sucesso!';
          lQuery.Connection.Commit;
        end;
        1:
        begin
          lQuery.ExecSQL;
          lMsg := 'ALTERADO com sucesso!';
          lQuery.Connection.Commit
        end;
      end;
    except
        on E: exception do
          Raise Exception.Create(E.Message);
    end;

    lJsonReq.Clear;
    lJsonReq.Put('success', True);
    lJsonReq.Put('message', lMsg);
    lJsonReq.Put('data', TConverter.New.LoadDataSet(lQuery).ToJSONArray);

  finally
    Result := lJsonReq.Stringify;
    FreeAndNil(lJsonReq);
    FreeAndNil(lQuery);
  end;
end;

function TDM.DeletePessoa(aID: Integer): string;
var
  lQuery: TZQuery;
  lJson: TJsonObject;
begin
  lQuery := TZQuery.Create(nil);
  try
    lQuery.Connection := ZConnection;
    lQuery.SQL.Add(' DELETE FROM pessoa ');
    lQuery.SQL.Add(' WHERE id = :id ');
    lQuery.Params[0].AsInteger := aID;

    lJson := TJsonObject.Create();
    try
      try
        if isExist(aID) then
        begin
          lQuery.ExecSQL;
          lJson.Put('success', True);
          lJson.Put('message', 'Deletado com sucesso!');
          lQuery.Connection.Commit;
        end
        else
        begin
          lJson.Put('success', False);
          lJson.Put('message', 'Produto inexistente!');
        end;

      except
        on E: exception do
        begin
           lJson.Put('success', False);
           lJson.Put('message', E.message);
        end;
      end;
    finally
      Result := lJson.Stringify;
      FreeAndNil(lJson);
    end;
  finally
    lQuery.Close;
    FreeAndNil(lQuery);
  end;
end;

function TDM.GetPessoaStructure: string;
var
  lJson: TJsonObject;
begin
  lJson := TJsonObject.Create();
  try
    try

      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add(' SELECT FIRST 0 * FROM pessoa');
      ZQuery.Open;

      lJson.Put('success', True);
      lJson.Put('structure', TConverter.New.LoadDataSet(ZQuery).ToJSONStructure);
      lJson.Put('data', TConverter.New.LoadDataSet(ZQuery).ToJSONArray);
    except
      on E: exception do
      begin
        lJson.Put('success', False);
        lJson.Put('message', E.Message);
      end;
    end;
  finally
    Result := lJson.Stringify;
    FreeAndNil(lJson);
  end;
end;

function TDM.GetDetailStructure(aTpPessoa: Integer): string;
var
  lJson: TJsonObject;
  lQuery: TZQuery;
begin
  lJson := TJsonObject.Create(nil);
  lQuery := TZQuery.Create(nil);
  try
    try
      lQuery.Connection := ZConnection;
      lQuery.Close;
      lQuery.SQL.Clear;
      case aTpPessoa of
        0:
        begin
          lQuery.SQL.Add(' SELECT FIRST 0 * FROM cliente');
        end;
        1:
        begin
          lQuery.SQL.Add(' SELECT FIRST 0 * FROM funcionario');
        end;
        2:
        begin
          lQuery.SQL.Add(' SELECT FIRST 0 * FROM fornecedor');
        end;
      end;
      lQuery.Open;

      lJson.Put('success', True);
      lJson.Put('structure', TConverter.New.LoadDataSet(lQuery).ToJSONStructure);
      lJson.Put('data', TConverter.New.LoadDataSet(lQuery).ToJSONArray);
    except
      on E: exception do
      begin
        lJson.Put('success', False);
        lJson.Put('message', E.Message);
      end;
    end;
  finally
    Result := lJson.Stringify;
    FreeAndNil(lJson);
    FreeAndNil(lQuery);
  end;
end;

function TDM.GetLastID: Integer;
var
  lQuery: TZQuery;
begin
  lQuery := TZQuery.Create(nil);
  try
    lQuery.Connection := ZConnection;
    lQuery.Connection.Connected := False;
    lQuery.Connection.Connected := False;
    lQuery.SQL.Clear;
    lQuery.SQL.Add('SELECT FIRST 1 id FROM pessoa ORDER BY ID DESC');
    lQuery.Open;

    Result := lQuery.FieldByName('id').AsInteger;

  finally
    lQuery.Close;
    FreeAndNil(lQuery);
  end;
end;

function TDM.GetTpPessoa(aID: Integer): Integer;
var
  lQuery: TZQuery;
  lJson: TJSONObject;
begin

  lQuery := TZQuery.Create(nil);
  lJson := TJSONObject.Create(nil);
  try
    lQuery.Connection := ZConnection;
    lQuery.SQL.Add(' SELECT tipo_pessoa FROM pessoa ');
    lQuery.SQL.Add(' WHERE id = :id ');
    lQuery.Params[0].AsInteger := aID;
    try
      lQuery.Open;

      Result := lQuery.FieldByName('tipo_pessoa').AsInteger;
    except
      on E: exception do
         Raise Exception.Create(E.Message);
    end;

  finally
    lQuery.Close;
    FreeAndNil(lQuery);
    FreeAndNil(lJson);
  end;

end;

end.

