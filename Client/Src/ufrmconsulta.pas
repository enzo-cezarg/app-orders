unit ufrmconsulta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, j4dl, dc4dl, rr4dl;

type

  { TFrmConsulta }

  TFrmConsulta = class(TForm)
    bdsCrudPessoas: TBufDataset;
    btnConsultar: TButton;
    btnClear: TButton;
    edtNome: TEdit;
    edtApelido: TEdit;
    edtCpfCnpj: TEdit;
    edtCep: TEdit;
    edtID: TEdit;
    lblCep: TLabel;
    lblCpfCnpj: TLabel;
    lblApelido: TLabel;
    lblNome: TLabel;
    lblID: TLabel;
    procedure btnConsultarClick(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure onAppend(aID: string);
    procedure datasetToView;
  public

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
  FrmConsulta.BorderStyle := _FORM_BORDER_STYLE;
  FrmConsulta.Width       := _FORM_WIDTH;
  FrmConsulta.Height      := _FORM_HEIGHT;
end;

procedure TFrmConsulta.btnConsultarClick(Sender: TObject);
begin
  if (Trim(edtID.Text) <> '') then
  begin
    FrmConsulta.onAppend(edtID.Text);
    FrmConsulta.datasetToView;
  end
  else
  begin
    edtID.Clear;
  end;
end;

procedure TFrmConsulta.btnClearClick(Sender: TObject);
begin

  edtNome.Clear;
  edtApelido.Clear;
  edtCpfCnpj.Clear;
  edtCep.Clear;

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
    edtCep.Clear;

    if bdsCrudPessoas.Active and (bdsCrudPessoas.RecordCount > 0) then
    begin
      edtID.Text            := IntToStr(bdsCrudPessoas.FieldByName('id').AsInteger);
      edtNome.Text          := bdsCrudPessoas.FieldByName('nome_razao').AsString;
      edtApelido.Text       := bdsCrudPessoas.FieldByName('apelido_fantasia').AsString;
      edtCpfCnpj.Text       := bdsCrudPessoas.FieldByName('cpf_cnpj').AsString;
      edtCep.Text           := bdsCrudPessoas.FieldByName('cep').AsString;
    end;
  except
    on E: exception do
       Raise Exception.Create(E.Message);
  end;
end;


end.

