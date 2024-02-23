unit ufrmconsulta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs, j4dl,
  dc4dl, rr4dl;

type

  { TFrmConsulta }

  TFrmConsulta = class(TForm)
    bdsCrudPessoas: TBufDataset;
    procedure FormCreate(Sender: TObject);
  private
    procedure onAppend(aID: Integer);
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

procedure TFrmConsulta.onAppend(aID: Integer);
var
  vlObjRes: IResponse;
  vlObjJson: TJSONObject;
begin
  vlObjJson := TJSONObject.Create;
  try
    try
      vlObjRes := TRequest.New.BaseURL('pessoa/:id')
                              .ContentType('application/json')
                              .AddHeader('conexao', vlObjJson.Stringify)
                              .Get;

      if (vlObjRes.StatusCode = 200) and (Trim(vlObjRes.Content) <> '') then
      begin
        if not vlObjJson.IsJsonObject(vlObjRes.Content) then
          Raise Exception.Create('JSON Invalido!');

        vlObjJson.Parse(vlObjRes.Content);

        if vlObjJson.Values['success'].AsBoolean then
        begin
          bdsCrudEntidades.Close;
          TConverter.New.LoadJson(vlObjJson.Values['structure'].AsArray).ToStructure(bdsCrudPessoas);
          TConverter.New.LoadJson(vlObjJson.Values['data'].AsArray).ToDataSet(bdsCrudPessoas);
          bdsCrudEntidades.Open;
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

end.

