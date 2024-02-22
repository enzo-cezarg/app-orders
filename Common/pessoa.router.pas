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

procedure SavePessoa(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lID: string;
begin
  if not aReq.Params.TryGetValue('id', lID) then
    lID := '0';

  aRes.ContentType('application/json')
  .Send( TPessoaService.SavePessoas( lID, aReq.Body ) );
end;

procedure DeletePessoa(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lID: string;
begin
  if not aReq.Params.TryGetValue('id', lID) then
    lID := '0';

  aRes.ContentType('application/json')
  .Send( TPessoaService.DeletePessoas(lID) );
end;

class procedure TPessoa.Router;
begin
  THorse.Get('/pessoa', GetPessoa)
  .Get('/pessoa/:id', GetPessoa)
  .Post('/pessoa', SavePessoa)
  .Put('/pessoa/:id', SavePessoa)
  .Delete('/pessoa/:id', DeletePessoa);
end;

end.

