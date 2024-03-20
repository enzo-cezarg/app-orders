program AppPedido;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, memdslaz, rxnew, zcomponent, uMainFrm, udmconexao, pessoa.router,
  pessoa.service, viacep.router, ufrmconsulta, uFrmDelete, ufrminsert, 
ufrmdetalhescliente, ufrmdetalhesfuncionario, ufrmdetalhesfornecedor;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmConsulta, FrmConsulta);
  Application.CreateForm(TFrmDelete, FrmDelete);
  Application.CreateForm(TFrmInsert, FrmInsert);
  Application.CreateForm(TfrmDetalhesCliente, frmDetalhesCliente);
  Application.CreateForm(TfrmDetalhesFuncionario, frmDetalhesFuncionario);
  Application.CreateForm(TfrmDetalhesFornecedor, frmDetalhesFornecedor);
  Application.Run;
end.

