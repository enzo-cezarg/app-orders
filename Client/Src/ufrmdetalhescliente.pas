unit ufrmdetalhescliente;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, MaskEdit;

type

  { TfrmDetalhesCliente }

  TfrmDetalhesCliente = class(TForm)
    edtLmtCred: TEdit;
    edtEmail: TEdit;
    lblEmail: TLabel;
    lblLmtCred: TLabel;
    lblTelF: TLabel;
    lblTelC: TLabel;
    lblObs: TLabel;
    mEdtTelF: TMaskEdit;
    mEdtTelC: TMaskEdit;
    mmObs: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmDetalhesCliente: TfrmDetalhesCliente;

const

  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 500;
  _FORM_HEIGHT = 300;

implementation

{$R *.lfm}

{ TfrmDetalhesCliente }

procedure TfrmDetalhesCliente.FormCreate(Sender: TObject);
begin
  frmDetalhesCliente.BorderStyle := _FORM_BORDER_STYLE;
  frmDetalhesCliente.Width       := _FORM_WIDTH;
  frmDetalhesCliente.Height      := _FORM_HEIGHT;
end;

end.

