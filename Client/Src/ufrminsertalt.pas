unit uFrmInsertAlt;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TFrmInsertAlt }

  TFrmInsertAlt = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

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
  FrmInsertAlt.BorderStyle := _FORM_BORDER_STYLE;
  FrmInsertAlt.Width       := _FORM_WIDTH;
  FrmInsertAlt.Height      := _FORM_HEIGHT;
end;

end.

