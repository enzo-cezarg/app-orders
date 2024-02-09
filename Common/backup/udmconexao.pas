unit udmconexao;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset;

type

  { TDM }

  TTpConexao = (tpFB);

  TDM = class(TDataModule)
    ZConnection: TZConnection;
    ZQuery: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure ZConnectionBeforeConnect(Sender: TObject);
  private
    FTpConexao: TTpConexao;
    procedure SetTpConexao(AValue: TTpConexao);

  public
    function Pessoas: string;
    property TpConexao: TTpConexao read FTpConexao write SetTpConexao;
  end;

var
  DM: TDM;

implementation

{$R *.lfm}

uses
  dc4dl, j4dl;

{ TDM }

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  FTpConexao := tpFB;
end;

procedure TDM.DataModuleDestroy(Sender: TObject);
begin
  ZQuery.Close;
  ZConnection.Connected := False;
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

function TDM.Pessoas: string;
var
  lJson: TJsonObject;
begin
  lJson := TJsonObject.Create();
  try
    try
      ZQuery.Close;
      ZQuery.SQL.Clear;
      ZQuery.SQL.Add('SELECT * FROM pessoa');
      ZQuery.SQL.Add('ORDER BY id');
      ZQuery.Open;

      lJson.Put('success', True);
      lJson.Put('message', Format('Total de Registros: %d', ZQuery.RecordCount));
      lJson.Put('data', TConverter.New.LoadDataSet(ZQuery).ToJSONArray);
    except
      on E: exception do
      begin
        lJson.Put('success', False);
        lJson.Put('message', E.Message);
      end;
    end;
  finally
    Result := lJson.Stringify;
    FreeAndNil(lJson);
  end;
end;

end.

