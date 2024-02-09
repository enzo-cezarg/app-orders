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
begin
  aRes.Content('application/json')
  .Send( TPessoaService.GetPessoas );
end;

class procedure TPessoa.Router;
begin
  THorse.Get('/pessoa', GetPessoa);
  // Define o que será enviado através da rota no endereço "/"
end;

end.

