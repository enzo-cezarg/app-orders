unit uFrmDelete;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs;

type

  { TFrmDelete }

  TFrmDelete = class(TForm)
    procedure FormCreate(Sender: TObject);
  private

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

end.

