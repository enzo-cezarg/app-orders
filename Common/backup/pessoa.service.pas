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
    class function SavePessoas(aJson: string): string;
    class function DeletePessoas(aID: string): string;
  end;

implementation

{ TPessoa }

class function TPessoaService.GetPessoas(aID: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.GetPessoa(StrToInt(aID));
  finally
    FreeAndNil(lDM);
  end;
end;

class function TPessoaService.SavePessoas(aJson: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.SavePessoa(aJson);
  finally
    FreeAndNil(lDM);
  end;

end;

class function TPessoaService.DeletePessoas(aID: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.DeletePessoa(StrToInt(aID));
  finally
    FreeAndNil(lDM);
  end;

end;


end.

