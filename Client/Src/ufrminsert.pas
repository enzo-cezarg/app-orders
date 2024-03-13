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
    Button1: TButton;
    Edit1: TEdit;
    Edit10: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtLog: TEdit;
    edtNum: TEdit;
    edtBairro: TEdit;
    edtCep: TEdit;
    edtMun: TEdit;
    edtUF: TEdit;
    Label1: TLabel;
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
    procedure btnSendInsertClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pgcSelectOpChange(Sender: TObject);
  private
    procedure getStructure;
    procedure datasetToView;
    procedure viewToDataset;
    function confirmOperation: Boolean;
    procedure onSave;
  public

  end;

var
  FrmInsert: TFrmInsert;
  _MSG_OPERATION: string;

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
    onSave;
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
         //
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
end;

function TFrmInsert.confirmOperation: Boolean;
begin
  Result := MessageDlg('Deseja confirmar?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TFrmInsert.onSave;
var
  lRes: IResponse;
  lJson: TJSONObject;
  aID: string;
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
      // TRequest.New.BaseURL(Format(_URL_CONEXAO, [aID]));
    end;
  end;
end;

end.

