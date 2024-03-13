unit udmconexao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

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
    function isExist(aID: Integer): Boolean;
  public
    function GetPessoa(aID: Integer): string;
    function SavePessoa(aID: Integer; aJson: string): string;
    function DeletePessoa(aID: Integer): string;
    function GetPessoaStructure: string;
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
begin
  lJson := TJsonObject.Create();
  try
    try
      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add(' SELECT * FROM pessoa');

      if (aID > -1) then
      begin
        ZQuery.SQL.Add(' WHERE id = :id ');
        ZQuery.Params[0].AsInteger := aID;
      // Procura por um ID específico se for passado como parâmetro
      end
      else
      begin
        ZQuery.SQL.Add(' WHERE id > 0 ');
      end;

      ZQuery.SQL.Add(' ORDER BY id ');
      ZQuery.Open;
      // Configura a query que buscará os dados no banco

      lJson.Put('success', True);
      lJson.Put('message', Format('Total de Registros: %d', [ZQuery.RecordCount]));
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
          lQuery.SQL.Add(' INSERT INTO pessoa                                    ');
          lQuery.SQL.Add(' (nome_razao, apelido_fantasia, cpf_cnpj,              ');
          lQuery.SQL.Add(' logradouro, numero, bairro, cep, municipio, uf)       ');
          lQuery.SQL.Add(' VALUES                                                ');
          lQuery.SQL.Add(' (:nome_razao, :apelido_fantasia, :cpf_cnpj,           ');
          lQuery.SQL.Add(' :logradouro, :numero, :bairro, :cep, :municipio, :uf) ');
          lQuery.SQL.Add(' RETURNING id                                          ');
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
            // Cria um json temporário com os dados no novo ID, transforma em objeto
            // e depois adiciona os dados ao json resultante para que seja retornado
            // pela função

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

end.

