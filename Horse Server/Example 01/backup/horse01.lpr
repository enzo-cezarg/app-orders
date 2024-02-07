program horse01;

{$if defined(fpc)}
  {$mode delphi}{$h+}
{$endif}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse, SysUtils, BaseRouter, viacep.router;

procedure OnListen(aListen: THorse);
begin
  WriteLn('Servidor ativo - ' + IntToStr(aListen.Port));
end;

begin
  TBase.Router;
  TViaCep.Router;

  THorse.Listen(9095, OnListen);
end.

