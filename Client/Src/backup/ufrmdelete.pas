unit uFrmDelete;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, j4dl, rr4dl, dc4dl;

type

  { TFrmDelete }

  TFrmDelete = class(TForm)
    bdsCrudPessoas: TBufDataset;
    btnSelect: TButton;
    btnDelete: TButton;
    edtID: TEdit;
    edtUF: TEdit;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtLog: TEdit;
    edtNum: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtMun: TEdit;
    lblID: TLabel;
    Label10: TLabel;
    lblNome: TLabel;
    lblApelido: TLabel;
    lblCpfCnpj: TLabel;
    lblLog: TLabel;
    lblNum: TLabel;
    lblBairro: TLabel;
    lblCep: TLabel;
    lblMun: TLabel;
    lblUF: TLabel;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure onAppend(aID: string);
    procedure onDelete(aID: string);
    procedure datasetToView;
    procedure clearFields;
    function confirmOperation: Boolean;
  public

  end;

var
  FrmDelete: TFrmDelete;

const

  // Definições do formulário
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 700;
  _FORM_HEIGHT = 350;

implementation

{$R *.lfm}

{ TFrmDelete }

procedure TFrmDelete.FormCreate(Sender: TObject);
begin
  FrmDelete.BorderStyle := _FORM_BORDER_STYLE;
  FrmDelete.Width       := _FORM_WIDTH;
  FrmDelete.Height      := _FORM_HEIGHT;
end;

procedure TFrmDelete.btnSelectClick(Sender: TObject);
begin
  if Trim(edtID.Text) <> '' then
    begin
      OnAppend(edtID.Text);
      datasetToView;
    end;
end;

procedure TFrmDelete.btnDeleteClick(Sender: TObject);
begin
  if confirmOperation then
  begin
    try

      onDelete(edtID.Text);
      ShowMessage('Deletado com sucesso!');
      onAppend(edtID.Text);
      datasetToView;

    except
        on E: exception do
          raise exception.create(E.message);
    end;
  end
  else
    ShowMessage('Operação cancelada!');
end;

procedure TFrmDelete.onAppend(aID: string);
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

procedure TFrmDelete.onDelete(aID: string);
var
  lRes: IResponse;
begin

  lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                        .ContentType('application/json')
                        .Delete;

end;

procedure TFrmDelete.datasetToView;
begin
  try

    clearFields;

    if bdsCrudPessoas.Active and (bdsCrudPessoas.RecordCount > 0) then
    begin
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

procedure TFrmDelete.clearFields;
begin
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

function TFrmDelete.confirmOperation: Boolean;
begin
  Result := MessageDlg('Deseja confirmar? (Esta ação não pode ser desfeita)', mtConfirmation, mbYesNo, 0) = mrYes;
end;

end.

