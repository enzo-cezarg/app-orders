unit ufrminsert;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, j4dl, rr4dl, dc4dl;

type

  { TFrmInsert }

  TFrmInsert = class(TForm)
    btnSendInsert: TButton;
    bdsCrudPessoas: TBufDataset;
    btnConsultaU: TButton;
    btnSendU: TButton;
    edtID: TEdit;
    edtUFU: TEdit;
    edtNomeU: TEdit;
    edtApelidoU: TEdit;
    edtCpfCnpjU: TEdit;
    edtLogU: TEdit;
    edtNumU: TEdit;
    edtBairroU: TEdit;
    edtCepU: TEdit;
    edtMunU: TEdit;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtLog: TEdit;
    edtNum: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtMun: TEdit;
    edtUF: TEdit;
    lblApelidoU: TLabel;
    lblCpfCnpjU: TLabel;
    lblLogU: TLabel;
    lblNumU: TLabel;
    lblBairroU: TLabel;
    lblCepU: TLabel;
    lblMunU: TLabel;
    lblUFU: TLabel;
    lblNomeU: TLabel;
    lblID: TLabel;
    lblNome: TLabel;
    lblApelido: TLabel;
    lblCpfCnpj: TLabel;
    lblLog: TLabel;
    lblNumero: TLabel;
    lblBairro: TLabel;
    lblCep: TLabel;
    lblMun: TLabel;
    lblUF: TLabel;
    lblEndereco: TLabel;
    lblDadosP: TLabel;
    pgcSelectOp: TPageControl;
    pgInsert: TTabSheet;
    pgUpdate: TTabSheet;
    procedure btnConsultaUClick(Sender: TObject);
    procedure btnSendInsertClick(Sender: TObject);
    procedure btnSendUClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pgcSelectOpChange(Sender: TObject);
  private
    procedure getStructure;
    procedure datasetToView;
    procedure viewToDataset;
    function confirmOperation: Boolean;
    procedure onSave(aID: string);
    procedure onAppend(aID: string);
  public

  end;

var
  FrmInsert: TFrmInsert;
  _MSG_OPERATION: string;
  _UPDATE_ID: string;

const

  // Definições do formulário
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 690;
  _FORM_HEIGHT = 400;

implementation

{$R *.lfm}

{ TFrmInsert }

procedure TFrmInsert.FormCreate(Sender: TObject);
begin
  FrmInsert.BorderStyle := _FORM_BORDER_STYLE;
  FrmInsert.Width := _FORM_WIDTH;
  FrmInsert.Height := _FORM_HEIGHT;

end;

procedure TFrmInsert.FormActivate(Sender: TObject);
begin
  getStructure;
  datasetToView;
end;

procedure TFrmInsert.btnSendInsertClick(Sender: TObject);
begin
  viewToDataset;
  if confirmOperation then
  begin
    onSave('0');
    ShowMessage(_MSG_OPERATION);
  end
  else
    ShowMessage('Operação cancelada!');
end;

procedure TFrmInsert.btnConsultaUClick(Sender: TObject);
begin
  onAppend(edtID.Text);
  datasetToView;
end;

procedure TFrmInsert.btnSendUClick(Sender: TObject);
begin
  viewToDataset;
  if confirmOperation then
  begin
    onSave(edtID.Text);
    ShowMessage(_MSG_OPERATION);
  end
  else
    ShowMessage('Operação cancelada!');
end;

procedure TFrmInsert.pgcSelectOpChange(Sender: TObject);
begin
  case pgcSelectOp.PageIndex of
    0:
    begin
      datasetToView;
    end;
    1:
    begin
       datasetToView;
    end;
  end;
end;



procedure TFrmInsert.getStructure;
var
  lJson: TJSONObject;
  lRes: IResponse;
begin
  try
    lJson := TJSONObject.Create;
    try
      lRes := TRequest.New.BaseURL('http://localhost:9095/pessoa/structure')
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise exception.Create('JSON Invalido!');

        lJson.Parse(lRes.Content);

        if lJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudPessoas.Open;
        end;
      end
      else
        Raise Exception.Create(lRes.Content);

    except
      on E: Exception do
        Raise Exception.Create(E.Message);
    end;
  finally
  end;
end;

procedure TFrmInsert.datasetToView;
begin
  try
    case pgcSelectOp.PageIndex of
      0: begin
         with edtNome do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtApelido do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtCpfCnpj do
         begin
           Clear;
           MaxLength := 14;
         end;
         with edtLog do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtNum do
         begin
           Clear;
           MaxLength := 13;
         end;
         with edtBairro do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtCep do
         begin
           Clear;
           MaxLength := 9;
         end;
         with edtMun do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtUF do
         begin
           Clear;
           MaxLength := 2;
         end;

         if (bdsCrudPessoas.Active) and (bdsCrudPessoas.RecordCount > 0 ) then
         begin
           edtNome.Text     := bdsCrudPessoas.FieldByName('nome_razao').AsString;
           edtApelido.Text  := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
           edtCpfCnpj.Text  := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
           edtLog.Text      := bdsCrudPessoas.FieldByName('logradouro').AsString;
           edtNum.Text      := bdsCrudPessoas.FieldByName('numero').AsString;
           edtBairro.Text   := bdsCrudPessoas.FieldByName('bairro').AsString;
           edtCep.Text      := bdsCrudPessoas.FieldByName('cep').AsString;
           edtMun.Text      := bdsCrudPessoas.FieldByName('municipio').AsString;
           edtUF.Text       := bdsCrudPessoas.FieldByName('uf').AsString;
         end;
      end;
      1: begin
         with edtNomeU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtApelidoU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtCpfCnpjU do
         begin
           Clear;
           MaxLength := 14;
         end;
         with edtLogU do
         begin
           Clear;
           MaxLength := 50;
         end;
         with edtNumU do
         begin
           Clear;
           MaxLength := 13;
         end;
         with edtBairroU do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtCepU do
         begin
           Clear;
           MaxLength := 9;
         end;
         with edtMunU do
         begin
           Clear;
           MaxLength := 35;
         end;
         with edtUFU do
         begin
           Clear;
           MaxLength := 2;
         end;

         if (bdsCrudPessoas.Active) and (bdsCrudPessoas.RecordCount > 0 ) then
         begin
           edtNomeU.Text     := bdsCrudPessoas.FieldByName('nome_razao').AsString;
           edtApelidoU.Text  := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
           edtCpfCnpjU.Text  := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
           edtLogU.Text      := bdsCrudPessoas.FieldByName('logradouro').AsString;
           edtNumU.Text      := bdsCrudPessoas.FieldByName('numero').AsString;
           edtBairroU.Text   := bdsCrudPessoas.FieldByName('bairro').AsString;
           edtCepU.Text      := bdsCrudPessoas.FieldByName('cep').AsString;
           edtMunU.Text      := bdsCrudPessoas.FieldByName('municipio').AsString;
           edtUFU.Text       := bdsCrudPessoas.FieldByName('uf').AsString;
         end;
      end;
    end;
  except
    on E: Exception do
      Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmInsert.viewToDataset;
begin
  if bdsCrudPessoas.Active then
  begin
    case pgcSelectOp.PageIndex of
      0:
      begin
        bdsCrudPessoas.Append;
        // bdsCrudPessoas.FieldByName('id').AsString := '0';
      end;
      1:
        bdsCrudPessoas.Edit;
    end;

    case pgcSelectOp.PageIndex of
      0:
      begin
        if (Trim(edtNome.Text) <> '') then
          bdsCrudPessoas.FieldByName('nome_razao').AsString := Trim(edtNome.Text);

        if (Trim(edtApelido.Text) <> '') then
          bdsCrudPessoas.FieldByName('apelido_fantasia').AsString := Trim(edtApelido.Text);

        if (Trim(edtCpfCnpj.Text) <> '') then
          bdsCrudPessoas.FieldByName('cpf_cnpj').AsString := Trim(edtCpfCnpj.Text);

        if (Trim(edtLog.Text) <> '') then
          bdsCrudPessoas.FieldByName('logradouro').AsString := Trim(edtLog.Text);

        if (Trim(edtNum.Text) <> '') then
          bdsCrudPessoas.FieldByName('numero').AsString := Trim(edtNum.Text);

        if (Trim(edtBairro.Text) <> '') then
          bdsCrudPessoas.FieldByName('bairro').AsString := Trim(edtBairro.Text);

        if (Trim(edtCep.Text) <> '') then
          bdsCrudPessoas.FieldByName('cep').AsString := Trim(edtCep.Text);

        if (Trim(edtMun.Text) <> '') then
          bdsCrudPessoas.FieldByName('municipio').AsString := Trim(edtMun.Text);

        if (Trim(edtUF.Text) <> '') then
          bdsCrudPessoas.FieldByName('uf').AsString := Trim(edtUF.Text);
        end;
      1:
      begin
        if (Trim(edtID.Text) <> '') then
          bdsCrudPessoas.FieldByName('id').AsString := Trim(edtID.Text);

        if (Trim(edtNomeU.Text) <> '') then
          bdsCrudPessoas.FieldByName('nome_razao').AsString := Trim(edtNomeU.Text);

        if (Trim(edtApelidoU.Text) <> '') then
          bdsCrudPessoas.FieldByName('apelido_fantasia').AsString := Trim(edtApelidoU.Text);

        if (Trim(edtCpfCnpjU.Text) <> '') then
          bdsCrudPessoas.FieldByName('cpf_cnpj').AsString := Trim(edtCpfCnpjU.Text);

        if (Trim(edtLogU.Text) <> '') then
          bdsCrudPessoas.FieldByName('logradouro').AsString := Trim(edtLogU.Text);

        if (Trim(edtNumU.Text) <> '') then
          bdsCrudPessoas.FieldByName('numero').AsString := Trim(edtNumU.Text);

        if (Trim(edtBairroU.Text) <> '') then
          bdsCrudPessoas.FieldByName('bairro').AsString := Trim(edtBairroU.Text);

        if (Trim(edtCepU.Text) <> '') then
          bdsCrudPessoas.FieldByName('cep').AsString := Trim(edtCepU.Text);

        if (Trim(edtMunU.Text) <> '') then
          bdsCrudPessoas.FieldByName('municipio').AsString := Trim(edtMunU.Text);

        if (Trim(edtUFU.Text) <> '') then
          bdsCrudPessoas.FieldByName('uf').AsString := Trim(edtUFU.Text);
      end;
    end;
  end;
end;

function TFrmInsert.confirmOperation: Boolean;
begin
  Result := MessageDlg('Deseja confirmar?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TFrmInsert.onSave(aID: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin
  case pgcSelectOp.PageIndex of
    0:
    begin
      try
        lJson := TJSONObject.Create(nil);
          try

            lJson.Assign(TConverter.New.LoadDataSet(bdsCrudPessoas).ToJSONObject);

            lRes := TRequest.New.BaseURL('http://localhost:9095/pessoa')
                            .ContentType('application/json')
                            .AddBody(lJson.Stringify)
                            .Post;

            if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
              _MSG_OPERATION := 'INCLUÍDO com sucesso!';


          except
            on E: exception do
              Raise Exception.Create(E.Message);
          end;
      finally
        FreeAndNil(lJson);
      end;
    end;
    1:
    begin
      try
        lJson := TJSONObject.Create(nil);
          try

            lJson.Assign(TConverter.New.LoadDataSet(bdsCrudPessoas).ToJSONObject);

            lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                            .ContentType('application/json')
                            .AddBody(lJson.Stringify)
                            .Put;

            if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
              _MSG_OPERATION := 'ALTERADO com sucesso!'
            else
              raise exception.create(lJson.Stringify);

          except
            on E: exception do
              Raise Exception.Create(E.Message);
          end;
      finally
        FreeAndNil(lJson);
      end;
    end;
  end;
end;

procedure TFrmInsert.onAppend(aID: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin
  try
    lJson := TJSONObject.Create(nil);

    try

      lRes := TRequest.New.BaseURL(Format('http://localhost:9095/pessoa/%s', [aID]))
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise Exception.Create('JSON Inválido!');

        lJson.Parse(lRes.Content);

        if lJson.Values['success'].AsBoolean then
        begin
          bdsCrudPessoas.Close;
          TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudPessoas.Open;
        end
        else
          Raise Exception.Create(lJson.Values['message'].AsString);
      end;
    except
      on E: Exception do
        Raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lJson);
  end;
end;

end.

