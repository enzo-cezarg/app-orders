unit pessoa.router;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, pessoa.service;

type

  { TBase }

  TPessoa = class
  public
    class procedure Router;
  end;

implementation

{ TBase }

procedure GetPessoa(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lID: string;
begin
  if not aReq.Params.TryGetValue('id', lID) then
    lID := '0';

  aRes.ContentType('application/json')
  .Send( TPessoaService.GetPessoas(lID) );
end;

class procedure TPessoa.Router;
begin
  THorse.Get('/pessoa', GetPessoa)
  // Define o que será enviado através da rota no endereço "/"
  .Get('/pessoa/:id', GetPessoa);
end;

end.

