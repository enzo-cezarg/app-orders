unit uDM;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TTpConexao = tpFB;

  TDM = class(TDataModule)
    ZConnection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
  private
    FTpConexao: TTpConexao;
    procedure SetTpConexao(AValue: TTpConexao);

  public
    property TpConexao: TTpConexao read FTpConexao write SetTpConexao;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FTpConexao := tpFB;
end;

procedure TDM.SetTpConexao(AValue: TTpConexao);
begin
  if FTpConexao = AValue then Exit;
  FTpConexao := AValue;
end;

end.
