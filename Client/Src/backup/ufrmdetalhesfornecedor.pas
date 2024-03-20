unit ufrmdetalhesfornecedor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TfrmDetalhesFornecedor }

  TfrmDetalhesFornecedor = class(TForm)
    edtEmail: TEdit;
    edtWebsite: TEdit;
    edtTel: TEdit;
    lblEmail: TLabel;
    lblWebsite: TLabel;
    lblTel: TLabel;
    lblObs: TLabel;
    mmObs: TMemo;
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmDetalhesFornecedor: TfrmDetalhesFornecedor;

const

  _FORM_BORDER_STYLE = bsDialog;
  _FORM_WIDTH = 500;
  _FORM_HEIGHT = 300;

implementation

{$R *.lfm}

{ TfrmDetalhesFornecedor }

procedure TfrmDetalhesFornecedor.FormCreate(Sender: TObject);
begin
  frmDetalhesFornecedor.BorderStyle := _FORM_BORDER_STYLE;
  frmDetalhesFornecedor.Width       := _FORM_WIDTH;
  frmDetalhesFornecedor.Height      := _FORM_HEIGHT;
end;

end.

