unit pessoa.service;

{$mode Delphi}

interface

uses
  Classes, SysUtils, udmconexao;

type

  { TPessoa }

  { TPessoaService }

  TPessoaService = class
  public
    class function GetPessoas(aID: string = '0'): string;
  end;

implementation

{ TPessoa }

class function TPessoaService.GetPessoas(aID: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.Pessoa(StrToInt(aID));
  finally
    FreeAndNil(lDM);
  end;
end;

end.

