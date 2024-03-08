unit uFrmInsertAlt;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, j4dl, dc4dl, rr4dl;

type

  { TFrmInsertAlt }

  TFrmInsertAlt = class(TForm)
    btnSend: TButton;
    bdsCrudPessoas: TBufDataset;
    btnConsulta: TButton;
    edtNome: TEdit;
    edtID: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtLog: TEdit;
    edtNum: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtMun: TEdit;
    edtUF: TEdit;
    lblSelectOp: TLabel;
    lblID: TLabel;
    lblEndereco: TLabel;
    lblNome: TLabel;
    lblSobrenome: TLabel;
    lblCpfCnpj: TLabel;
    lblLogradouro: TLabel;
    lblNumero: TLabel;
    lblBairro: TLabel;
    lblCep: TLabel;
    lblMunicipio: TLabel;
    lblUF: TLabel;
    lblTtlDados: TLabel;
    rInsert: TRadioButton;
    rUpdate: TRadioButton;
    procedure btnConsultaClick(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure rInsertChange(Sender: TObject);
  private
    procedure getStructure;
    procedure OnAppend(aID: string);
    procedure datasetToView;
    procedure viewToDataset;
    function confirmOperation: Boolean;
  public

  end;

var
  FrmInsertAlt: TFrmInsertAlt;

const

  // Definições do formulário
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 700;
  _FORM_HEIGHT = 350;

implementation

{$R *.lfm}

{ TFrmInsertAlt }

procedure TFrmInsertAlt.FormCreate(Sender: TObject);
begin

  FrmInsertAlt.BorderStyle   := _FORM_BORDER_STYLE;
  FrmInsertAlt.Width         := _FORM_WIDTH;
  FrmInsertAlt.Height        := _FORM_HEIGHT;

end;

procedure TFrmInsertAlt.rInsertChange(Sender: TObject);
begin
  
  if rInsert.Checked then
  begin
    edtID.Text := '0';
    edtID.Enabled := False;
  end
  else
  begin
    edtID.Clear;
    edtID.Enabled := True;
  end;
end;

procedure TFrmInsertAlt.btnConsultaClick(Sender: TObject);
begin

  try
    if Trim(edtID.Text) <> '' then
    begin
      FrmInsertAlt.OnAppend(edtID.Text);
      FrmInsertAlt.datasetToView;
    end
    else
    begin
      FrmInsertAlt.getStructure;
    end;
  except
    on E: exception do
      Raise Exception.Create(E.Message);
  end;

end;

procedure TFrmInsertAlt.btnSendClick(Sender: TObject);
begin
  if confirmOperation then
    FrmInsertAlt.viewToDataset
  else
    ShowMessage('Operação Cancelada!')

end;

procedure TFrmInsertAlt.getStructure;
var
  vlObjRes: IResponse;
  vlObjJson: TJSONObject;
begin
  vlObjJson := TJSONObject.Create;
  try
    try
      vlObjRes := TRequest.New.BaseURL('http://localhost:9095/pessoa/structure')
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

procedure TFrmInsertAlt.OnAppend(aID: string);
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

procedure TFrmInsertAlt.datasetToView;
begin
  try

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

procedure TFrmInsertAlt.viewToDataset;
begin
   if bdsCrudPessoas.Active then
   begin
     try
       if rInsert.Checked then
       begin
         bdsCrudPessoas.Append;
         bdsCrudPessoas.FieldByName('id').AsString := '0';
       end
       else if rUpdate.Checked then
         bdsCrudPessoas.Edit;

       if Trim(edtNome.Text) <> '' then
         bdsCrudPessoas.FieldByName('nome_razao').AsString       := Trim(edtNome.Text);

       if Trim(edtApelido.Text) <> '' then
         bdsCrudPessoas.FieldByName('apelido_fantasia').AsString := Trim(edtApelido.Text);

       if Trim(edtCpfCnpj.Text) <> '' then
         bdsCrudPessoas.FieldByName('cpf_cnpj').AsString         := Trim(edtCpfCnpj.Text);

       if Trim(edtLog.Text) <> '' then
         bdsCrudPessoas.FieldByName('logradouro').AsString       := Trim(edtLog.Text);

       if Trim(edtNum.Text) <> '' then
         bdsCrudPessoas.FieldByName('numero').AsString           := Trim(edtNum.Text);

       if Trim(edtBairro.Text) <> '' then
         bdsCrudPessoas.FieldByName('bairro').AsString           := Trim(edtBairro.Text);

       if Trim(edtCep.Text) <> '' then
         bdsCrudPessoas.FieldByName('cep').AsString              := Trim(edtCep.Text);

       if Trim(edtMun.Text) <> '' then
         bdsCrudPessoas.FieldByName('municipio').AsString        := Trim(edtMun.Text);

       if Trim(edtUF.Text) <> '' then
         bdsCrudPessoas.FieldByName('uf').AsString               := Trim(edtUF.Text);

     except
       on E: Exception do
         raise Exception.Create(E.Message);
     end;
   end;
end;

function TFrmInsertAlt.confirmOperation: Boolean;
begin
  Result := MessageDlg('Deseja confirmar?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

end.

