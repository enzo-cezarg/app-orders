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

procedure SavePessoaDetails(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lID: string;
begin
  if not aReq.Params.TryGetValue('id', lID) then
    lID := '0';

  aRes.ContentType('application/json')
  .Send( TPessoaService.SavePessoaDetails( lID, aReq.Body ) );
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

procedure GetPessoaStructure(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
begin

  aRes.ContentType('application/json')
  .Send( TPessoaService.GetPessoaStructure );

end;

procedure GetDetailStructure(aReq: THorseRequest; aRes: THorseResponse; aNext: TNextProc);
var
  lTpPessoa: string;
begin
  if not aReq.Params.TryGetValue('tipo_pessoa', lTpPessoa) then
    lTpPessoa := '-1';

  aRes.ContentType('application/json')
  .Send( TPessoaService.GetDetailStructure(lTpPessoa) );

end;

class procedure TPessoa.Router;
begin
  THorse.Get('/pessoa', GetPessoa)
  .Get('/pessoa/:id', GetPessoa)
  .Get('/pessoa/structure', GetPessoaStructure)
  .Get('/pessoa/detail/structure/:tipo_pessoa', GetDetailStructure)
  //.Post('/pessoa', SavePessoa)
  .Put('/pessoa', SavePessoa)
  .Put('/pessoa/:id', SavePessoa)
  .Put('/pessoa/detail/:id', SavePessoaDetails)
  .Delete('/pessoa/:id', DeletePessoa);


end;

end.

