unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TDM = class(TDataModule)
    ZConnection: TZConnection;
  private

  public

  end;

var
  DM: TDM;

implementation

{$R *.lfm}

end.

