unit ufrmconsultacep;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, memds, Forms, Controls, Graphics, Dialogs,
  StdCtrls, j4dl, rr4dl, dc4dl;

type

  { TFrmConsultaCep }

  TFrmConsultaCep = class(TForm)
    bdsViaCep: TBufDataset;
    edtCep: TEdit;
    edtGIA: TEdit;
    edtLoc: TEdit;
    edtLog: TEdit;
    edtUF: TEdit;
    edtBairro: TEdit;
    edtDDD: TEdit;
    edtComp: TEdit;
    edtIBGE: TEdit;
    edtSIAFI: TEdit;
    lblCep: TLabel;
    lblGIA: TLabel;
    lblLoc: TLabel;
    lblUF: TLabel;
    lblDDD: TLabel;
    lblLog: TLabel;
    lblBairro: TLabel;
    lblComp: TLabel;
    lblIBGE: TLabel;
    lblSIAFI: TLabel;
  private
    procedure onAppend(aCEP: string);
    procedure datasetToView;
  public
    procedure getCep(aCEP: string);
  end;

var
  FrmConsultaCep: TFrmConsultaCep;

const
  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 300;
  _FORM_HEIGHT = 400;

implementation

{$R *.lfm}

{ TFrmConsultaCep }

procedure TFrmConsultaCep.onAppend(aCEP: string);
var
  lRes: IResponse;
  lJson: TJSONObject;
begin
  try
    lJson := TJSONObject.Create(nil);
    try

      lRes := TRequest.New.BaseURL(Format('http://viacep.com.br/ws/%s/json/', [aCEP]))
                          .ContentType('application/json')
                          .Get;

      if (lRes.StatusCode = 200) and (Trim(lRes.Content) <> '') then
      begin
        if not lJson.IsJsonObject(lRes.Content) then
          Raise Exception.Create('JSON Invalido!');

        lJson.Parse(lRes.Content);

        bdsViaCep.Close;
        // TConverter.New.LoadJson(lJson.Values['structure'].AsArray).ToStructure(bdsViaCep);
        // TConverter.New.LoadJson(lJson.Values['data'].AsArray).ToDataSet(bdsViaCep);


        bdsViaCep.Open;

      end
      else
        Raise Exception.Create(lRes.Content);
    except
      on E: exception do
        Raise Exception.Create(E.Message);
    end;
  finally
    FreeAndNil(lJson);
  end;
end;

procedure TFrmConsultaCep.datasetToView;
begin
  try

    edtCep.Clear;
    edtLoc.Clear;
    edtLog.Clear;
    edtUF.Clear;
    edtBairro.Clear;
    edtDDD.Clear;
    edtComp.Clear;
    edtIBGE.Clear;
    edtSIAFI.Clear;
    edtGIA.Clear;

    if bdsViaCep.Active and (bdsViaCep.RecordCount > 0) then
    begin
      edtCep.Text      := bdsViaCep.FieldByName('cep').AsString;
      edtLoc.Text      := bdsViaCep.FieldByName('localidade').AsString;
      edtLog.Text      := bdsViaCep.FieldByName('logradouro').AsString;
      edtUF.Text       := bdsViaCep.FieldByName('uf').AsString;
      edtBairro.Text   := bdsViaCep.FieldByName('bairro').AsString;
      edtDDD.Text      := bdsViaCep.FieldByName('ddd').AsString;
      edtComp.Text     := bdsViaCep.FieldByName('complemento').AsString;
      edtIBGE.Text     := bdsViaCep.FieldByName('ibge').AsString;
      edtSIAFI.Text    := bdsViaCep.FieldByName('siafi').AsString;
      edtGIA.Text      := bdsViaCep.FieldByName('gia').AsString;
    end;
  except
    on E: exception do
       Raise Exception.Create(E.Message);
  end;
end;

procedure TFrmConsultaCep.getCep(aCEP: string);
begin
  if Trim(aCEP) <> '' then
  begin
    onAppend(Trim(aCEP));
    datasetToView;
  end;
end;

end.

