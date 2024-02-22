unit uMainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DBGrids, Menus, RxDBGrid, rxmemds, ZDataset, ufrmconsulta,
  uFrmInsertAlt, uFrmDelete;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    BufDataset: TBufDataset;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    dsQuery: TDataSource;
    dsMemTbl: TDataSource;
    dbgMemTbl: TDBGrid;
    dbgQuery: TDBGrid;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    menuConsultaID: TMenuItem;
    menuInsertAlt: TMenuItem;
    menuDelete: TMenuItem;
    mmJson: TMemo;
    pnlTop: TPanel;
    RxMemoryData: TRxMemoryData;
    ZQuery: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menuConsultaIDClick(Sender: TObject);
    procedure menuInsertAltClick(Sender: TObject);
    procedure menuDeleteClick(Sender: TObject);
  private

  public

  end;

var
   MainFrm: TMainFrm;

implementation

{$R *.lfm}

{ TMainFrm }

uses udmconexao;

procedure TMainFrm.FormResize(Sender: TObject);
begin
  mmJson.Height    := Trunc((Self.Height - (39 + pnlTop.Height)) / 3);
  dbgMemTbl.Height := mmJson.Height;
end;

procedure TMainFrm.menuConsultaIDClick(Sender: TObject);
begin
  FrmConsulta.ShowModal;
end;

procedure TMainFrm.menuInsertAltClick(Sender: TObject);
begin
  FrmInsertAlt.ShowModal;
end;

procedure TMainFrm.menuDeleteClick(Sender: TObject);
begin
  FrmDelete.ShowModal;
end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  if not Assigned( DM ) then
     Application.CreateForm(TDM, DM);

  ZQuery.Connection := DM.ZConnection;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
begin
  ZQuery.Active := not ZQuery.Active;
end;

procedure TMainFrm.Button2Click(Sender: TObject);
begin
  dsMemTbl.DataSet.Active := not dsMemTbl.DataSet.Active;
end;

procedure TMainFrm.Button3Click(Sender: TObject);
var
   lStream: TMemoryStream;
   lBuf: TBufDataSet;
begin
  dsMemTbl.DataSet := BufDataSet;

  if BufDataSet.Active then
     BufDataSet.Close;

  lStream := TMemoryStream.Create;
  lBuf := TBufDataSet.Create(nil);
  try
    lBuf.CopyFromDataset( ZQuery );
    lBuf.SaveToStream( lStream, dfBinary );
    lStream.Position := 0;
    BufDataSet.LoadFromStream( lStream, dfBinary );
  finally
    FreeAndNil(lStream);
    lBuf.Close;
    FreeAndNil(lBuf);
  end;

end;

procedure TMainFrm.Button4Click(Sender: TObject);
var
   lStream: TMemoryStream;
   lMtb: TRxMemoryData;
begin
  dsMemTbl.DataSet := RxMemoryData;

  if RxMemoryData.Active then
    RxMemoryData.Close;

  lStream := TMemoryStream.Create;
  lMtb := TRxMemoryData.Create(nil);
  try
    lMtb.LoadFromDataSet( ZQuery, 0, lmCopy );
    lMtb.SaveToStream( lStream );
    lStream.Position := 0;
    RxMemoryData.LoadFromStream( lStream );
  finally
    FreeAndNil(lStream);
    lMtb.Close;
    FreeAndNil(lMtb);
  end;
  // RxMemoryData.LoadFromDataSet( ZQuery, 0, lmCopy );
end;

end.
