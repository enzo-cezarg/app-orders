unit ufrmconsulta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, MaskEdit, j4dl, dc4dl, rr4dl, udmconexao, ufrmdetalhescliente,
  ufrmdetalhesfuncionario, ufrmdetalhesfornecedor;

type

  { TFrmConsulta }

  TFrmConsulta = class(TForm)
    bdsCrudPessoas: TBufDataset;
    btnConsultar: TButton;
    btnClear: TButton;
    btnShowDetail: TButton;
    edtTipo: TEdit;
    edtLog: TEdit;
    edtBairro: TEdit;
    edtNum: TEdit;
    edtMun: TEdit;
    edtUF: TEdit;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtCep: TEdit;
    edtID: TEdit;
    lblDadosP: TLabel;
    lblEndereco: TLabel;
    lblTipo: TLabel;
    lblLog: TLabel;
    lblNum: TLabel;
    lblBairro: TLabel;
    lblMun: TLabel;
    lblUF: TLabel;
    lblCep: TLabel;
    lblCpfCnpj: TLabel;
    lblApelido: TLabel;
    lblNome: TLabel;
    lblID: TLabel;
    procedure btnConsultarClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure btnShowDetailClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure onAppend(aID: string);
    procedure datasetToView;
    procedure putData(lTpPessoa: integer);
  public
    procedure getID(aID: string);
  end;

var
  FrmConsulta: TFrmConsulta;

const

  // Definições do formulário
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 700;
  _FORM_HEIGHT = 350;

implementation

{$R *.lfm}

{ TFrmConsulta }

procedure TFrmConsulta.FormCreate(Sender: TObject);
begin

  bdsCrudPessoas.Active := False;

  FrmConsulta.BorderStyle := _FORM_BORDER_STYLE;
  FrmConsulta.Width       := _FORM_WIDTH;
  FrmConsulta.Height      := _FORM_HEIGHT;
end;

procedure TFrmConsulta.btnConsultarClick(Sender: TObject);
var
  lTpPessoa: integer;
begin
  lTpPessoa := DM.GetTpPessoa(StrToInt(edtID.Text));

  if (Trim(edtID.Text) <> '') then
  begin
    FrmConsulta.onAppend(edtID.Text);
    FrmConsulta.datasetToView;
    case lTpPessoa of
      0: edtTipo.Text := 'Cliente';
      1: edtTipo.Text := 'Funcionário';
      2: edtTipo.Text := 'Fornecedor';
    end;
  end
  else
  begin
    edtID.Clear;
  end;
end;

procedure TFrmConsulta.btnClearClick(Sender: TObject);
begin

  edtID.Clear;
  edtTipo.Clear;
  edtNome.Clear;
  edtApelido.Clear;
  edtCpfCnpj.Clear;
  edtLog.Clear;
  edtNum.Clear;
  edtBairro.Clear;
  edtCep.Clear;
  edtMun.Clear;
  edtUF.Clear;

end;

procedure TFrmConsulta.btnShowDetailClick(Sender: TObject);
var
  lTpPessoa: integer;
begin
  lTpPessoa := DM.GetTpPessoa(StrToInt(edtID.Text));
  try
    case lTpPessoa of
      0: begin
        putData(lTpPessoa);
        frmDetalhesCliente.ShowModal;
      end;
      1: begin
        putData(lTpPessoa);
        frmDetalhesFuncionario.ShowModal;
      end;
      2: begin
        putData(lTpPessoa);
        frmDetalhesFornecedor.ShowModal;
      end;
    end;

  except
    on E: Exception do
      Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmConsulta.onAppend(aID: string);
var
  vlObjRes: IResponse;
  vlObjJson: TJSONObject;
begin
  vlObjJson := TJSONObject.Create;
  try
    try
      vlObjRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                              .ContentType('application/json')
                              //.AddHeader('conexao', vlObjJson.Stringify)
                              .Get;

      if (vlObjRes.StatusCode = 200) and (Trim(vlObjRes.Content) <> '') then
      begin
        if not vlObjJson.IsJsonObject(vlObjRes.Content) then
          Raise Exception.Create('JSON Invalido!');

        vlObjJson.Parse(vlObjRes.Content);

        if vlObjJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(vlObjJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(vlObjJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudPessoas.Open;
        end
        else
          Raise exception.Create(vlObjJson.Values['message'].AsString);
      end
      else
        Raise exception.Create(vlObjRes.Content);
    except
      on E: exception do
        Raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(vlObjJson);
  end;
end;

procedure TFrmConsulta.datasetToView;
begin
  try

    edtID.Clear;
    edtNome.Clear;
    edtApelido.Clear;
    edtCpfCnpj.Clear;
    edtLog.Clear;
    edtNum.Clear;
    edtBairro.Clear;
    edtCep.Clear;
    edtMun.Clear;
    edtUF.Clear;

    if bdsCrudPessoas.Active and (bdsCrudPessoas.RecordCount > 0) then
    begin
      edtID.Text            := IntToStr(bdsCrudPessoas.FieldByName('id').AsInteger);
      edtNome.Text          := bdsCrudPessoas.FieldByName('nome_razao').AsString;
      edtApelido.Text       := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
      edtCpfCnpj.Text       := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
      edtLog.Text           := bdsCrudPessoas.FieldByName('logradouro').AsString;
      edtNum.Text           := bdsCrudPessoas.FieldByName('numero').AsString;
      edtBairro.Text        := bdsCrudPessoas.FieldByName('bairro').AsString;
      edtCep.Text           := bdsCrudPessoas.FieldByName('cep').AsString;
      edtMun.Text           := bdsCrudPessoas.FieldByName('municipio').AsString;
      edtUF.Text            := bdsCrudPessoas.FieldByName('uf').AsString;
    end;
  except
    on E: exception do
       Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmConsulta.putData(lTpPessoa: integer);
begin
  if bdsCrudPessoas.Active and (bdsCrudPessoas.RecordCount > 0) then
  begin

      case lTpPessoa of
         0: begin
           frmDetalhesCliente.edtEmail.Clear;
           frmDetalhesCliente.edtLmtCred.Clear;
           frmDetalhesCliente.mEdtTelF.Clear;
           frmDetalhesCliente.mEdtTelC.Clear;
           frmDetalhesCliente.mmObs.Clear;

           frmDetalhesCliente.edtEmail.Text   := bdsCrudPessoas.FieldByName('email').AsString;
           frmDetalhesCliente.edtLmtCred.Text := IntToStr(bdsCrudPessoas.FieldByName('limite_credito').AsInteger);
           frmDetalhesCliente.mEdtTelF.Text   := bdsCrudPessoas.FieldByName('telefone_fixo').AsString;
           frmDetalhesCliente.mEdtTelC.Text   := bdsCrudPessoas.FieldByName('telefone_celular').AsString;
           frmDetalhesCliente.mmObs.Append(bdsCrudPessoas.FieldByName('obs').AsString);
         end;
         1: begin
           frmDetalhesFuncionario.edtEmail.Clear;
           frmDetalhesFuncionario.edtCargo.Clear;
           frmDetalhesFuncionario.edtUser.Clear;
           frmDetalhesFuncionario.edtSenha.Clear;
           frmDetalhesFuncionario.edtComissao.Clear;

           frmDetalhesFuncionario.edtEmail.Text    := bdsCrudPessoas.FieldByName('email').AsString;
           frmDetalhesFuncionario.edtUser.Text     := bdsCrudPessoas.FieldByName('login').AsString;
           frmDetalhesFuncionario.edtSenha.Text    := bdsCrudPessoas.FieldByName('senha').AsString;
           frmDetalhesFuncionario.edtComissao.Text := IntToStr(bdsCrudPessoas.FieldByName('comissao').AsInteger);

           if bdsCrudPessoas.FieldByName('master').AsInteger = 1 then
             frmDetalhesFuncionario.edtCargo.Text := 'Gerente'
           else
             frmDetalhesFuncionario.edtCargo.Text := 'Funcionário';
         end;
         2: begin
           frmDetalhesFornecedor.edtEmail.Clear;
           frmDetalhesFornecedor.edtWebsite.Clear;
           frmDetalhesFornecedor.edtTel.Clear;
           frmDetalhesFornecedor.mmObs.Clear;

           frmDetalhesFornecedor.edtEmail.Text   := bdsCrudPessoas.FieldByName('email').AsString;;
           frmDetalhesFornecedor.edtWebsite.Text := bdsCrudPessoas.FieldByName('website').AsString;;
           frmDetalhesFornecedor.edtTel.Text     := bdsCrudPessoas.FieldByName('telefone').AsString;;
           frmDetalhesFornecedor.mmObs.Append(bdsCrudPessoas.FieldByName('obs').AsString);
         end;

      end;
  end;
end;

procedure TFrmConsulta.getID(aID: string);
begin
  if Trim(aID) <> '' then
  begin
    onAppend(aID);
    datasetToView;
  end;
end;


end.

