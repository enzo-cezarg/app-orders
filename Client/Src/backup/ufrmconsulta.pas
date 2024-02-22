unit ufrmconsulta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TFrmConsulta }

  TFrmConsulta = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

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
  // Definições do formulário
  FrmConsulta.BorderStyle := _FORM_BORDER_STYLE;
  FrmConsulta.Width       := _FORM_WIDTH;
  FrmConsulta.Height      := _FORM_HEIGHT;
end;

end.

