program horse01;

{$mode delphi}

uses
  Horse, SysUtils;

procedure OnListen(aListen: THorse);
begin
  WriteLn('Servidor ativo - ' + IntToStr(aListen.Port));
end;

begin
  THorse.Listen(9095, OnListen);
end.

