unit service.pessoas;

{$mode Delphi}

interface

uses
  Classes, SysUtils, udmconexao;

type

  { TPessoas }

  TPessoa = class
  public
    class function GetPessoas: string;
  end;

implementation

{ TPessoas }

class function TPessoas.GetPessoas: string;
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

