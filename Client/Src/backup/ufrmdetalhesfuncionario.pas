unit ufrmdetalhesfuncionario;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmDetalhesFuncionario }

  TfrmDetalhesFuncionario = class(TForm)
    edtEmail: TEdit;
    edtComissao: TEdit;
    edtUser: TEdit;
    edtSenha: TEdit;
    edtCargo: TEdit;
    lblEmail: TLabel;
    lblComissao: TLabel;
    lblUser: TLabel;
    lblSenha: TLabel;
    lblCargo: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmDetalhesFuncionario: TfrmDetalhesFuncionario;

const

  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 500;
  _FORM_HEIGHT = 300;

implementation

{$R *.lfm}

{ TfrmDetalhesFuncionario }

procedure TfrmDetalhesFuncionario.FormCreate(Sender: TObject);
begin
  frmDetalhesFuncionario.BorderStyle := _FORM_BORDER_STYLE;
  frmDetalhesFuncionario.Width       := _FORM_WIDTH;
  frmDetalhesFuncionario.Height      := _FORM_HEIGHT;
end;

end.

