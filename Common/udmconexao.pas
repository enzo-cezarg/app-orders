unit udmconexao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDM }

  TTpConexao = (tpFB);

  TDM = class(TDataModule)
    ZConnection: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure ZConnectionBeforeConnect(Sender: TObject);
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

procedure TDM.ZConnectionBeforeConnect(Sender: TObject);
begin
  ZConnection.Database := 'C:\Users\User\Desktop\Repositórios\AppPedidos\Database\APPORDERS.FDB';
  ZConnection.Protocol := 'firebird';
  ZConnection.Port := 3050;
  ZConnection.User := 'SYSDBA';
  ZConnection.Password := 'masterkey';

  {$IFDEF WIN32}
  ZConnection.LibLocation := '';
  {$ELSE}
  ZConnection.LibLocation := '';
  {$ENDIF}
end;

procedure TDM.SetTpConexao(AValue: TTpConexao);
begin
  if FTpConexao = AValue then Exit;
  FTpConexao := AValue;
end;

end.

