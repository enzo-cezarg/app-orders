unit viacep.router;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, rr4dl, j4dl;

type

  { TBase }

  TViaCep = class
  public
    class procedure Router;
  end;

implementation

{ TBase }

procedure OnViaCep(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lRes: IResponse;
  lCep: string;
begin
  if not aReq.Params.TryGetValue('cep', lCep) then
    lCep := '00000000';

  lRes := TRequest.New.BaseURL(Format('viacep.com.br/ws/%s/json/', [lCep]))
  .ContentType('application/json')
  .Get;

  if (lRes.StatusCode = 200) then
    aRes.ContentType('application/json').Send( lRes.Content )
  else
    aRes.ContentType('application/json').Status( lRes.StatusCode ).Send( 'Error!' );
end;

class procedure TViaCep.Router;
begin
  THorse.Get('/cep/:cep', OnViaCep);
end;

end.

