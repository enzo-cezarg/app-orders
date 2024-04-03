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
    class function SavePessoas(aID, aJson: string): string;
    class function SavePessoaDetails(aID, aJson: string): string;
    class function DeletePessoas(aID: string): string;
    class function GetPessoaStructure: string;
    class function GetDetailStructure(aTpPessoa: string): string;
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

class function TPessoaService.SavePessoas(aID, aJson: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.SavePessoa(StrToInt(aID), aJson);
  finally
    FreeAndNil(lDM);
  end;

end;

class function TPessoaService.SavePessoaDetails(aID, aJson: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.SavePessoaDetails(StrToInt(aID), aJson);
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

class function TPessoaService.GetPessoaStructure: string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.GetPessoaStructure;
  finally
    FreeAndNil(lDM);
  end;

end;

class function TPessoaService.GetDetailStructure(aTpPessoa: string): string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.GetDetailStructure(aTpPessoa);
  finally
    FreeAndNil(lDM);
  end;
end;


end.

