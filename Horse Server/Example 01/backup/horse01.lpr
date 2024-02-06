program horse01;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

uses
  Horse, SysUtils, BaseRouter;

procedure OnListen(aListen: THorse);
begin
  WriteLn('Servidor ativo - ' + IntToStr(aListen.Port));
end;

begin


  THorse.Listen(9095, OnListen);
end.

