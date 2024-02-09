unit pessoa.service;

{$mode Delphi}

interface

uses
  Classes, SysUtils, udmconexao;

type

  { TPessoa }

  TPessoa = class
  public
    class function GetPessoas: string;
  end;

implementation

{ TPessoa }

class function TPessoa.GetPessoas: string;
var
  lDM: TDM;
begin
  lDM := TDM.Create(nil);
  try
    Result := lDM.Pessoas;
  finally
    FreeAndNil(lDM);
  end;
end;

end.

