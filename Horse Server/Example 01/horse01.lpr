program horse01;

{$if defined(fpc)}
  {$mode delphi}{$h+}
{$endif}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Horse, Horse.BasicAuthentication, SysUtils, BaseRouter, viacep.router;

function OnAuth(const aUser, aPass: string): Boolean;
begin
  Result := aUser.Equals('admin') and aPass.Equals('admin');
end;

{$IFDEF HORSE_CGI}
{$ELSE}
procedure OnListen(aListen: THorse);
begin
  WriteLn('Servidor ativo - ' + IntToStr(aListen.Port));
end;
{$ENDIF}

begin
  // Middlewares
  THorse.Use(HorseBasicAuthentication(OnAuth));

  // Rotas
  TBase.Router;
  TViaCep.Router;

  {$IFDEF HORSE_CGI} // Para servidores CGI
    THorse.Listen;
  {$ELSE} // Para servidores Console
    THorse.Listen(9095, OnListen);
  {$ENDIF}

end.

