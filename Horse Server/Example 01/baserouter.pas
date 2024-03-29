unit BaseRouter;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse;

type

  { TBase }

  TBase = class
  public
    class procedure Router;
  end;

implementation

{ TBase }

procedure OnStatus(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
begin
  aRes.ContentType('text/html')
  .Send('<h2>Servidor Horse Ativo...</h2>');
end;

class procedure TBase.Router;
begin
  THorse.Get('/', OnStatus);
  // Define o que será enviado através da rota no endereço "/"
end;

end.

