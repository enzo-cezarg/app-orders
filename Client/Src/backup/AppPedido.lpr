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
  Forms, rxnew, zcomponent, uMainFrm, udmconexao, pessoa.router, pessoa.service,
  viacep.router, ufrmconsulta, uFrmInsertAlt, uFrmDelete, ufrminsert;

{$R *.res}

begin
  RequireDerivedFormResource := True;
  Application.Scaled := True;
  Application.Initialize;
  Application.CreateForm(TMainFrm, MainFrm);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrmConsulta, FrmConsulta);
  Application.CreateForm(TFrmInsertAlt, FrmInsertAlt);
  Application.CreateForm(TFrmDelete, FrmDelete);
  Application.Run;
end.

