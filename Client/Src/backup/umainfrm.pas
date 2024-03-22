unit uMainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, BufDataset, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DBGrids, Menus, RxDBGrid, rxmemds, ZDataset, ufrmconsulta,
  uFrmDelete, ufrminsert, udmconexao;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    BufDataset: TBufDataset;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    dsQuery: TDataSource;
    dsMemTbl: TDataSource;
    dbgMemTbl: TDBGrid;
    dbgQuery: TDBGrid;
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    menuConsultaID: TMenuItem;
    menuInsertAlt: TMenuItem;
    menuDelete: TMenuItem;
    menuConsultaTp: TMenuItem;
    menuConsultaCl: TMenuItem;
    menuConsultaFu: TMenuItem;
    menuConsultaFo: TMenuItem;
    mmJson: TMemo;
    pnlTop: TPanel;
    RxMemoryData: TRxMemoryData;
    ZQuery: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure dbgQueryCellClick(Column: TColumn);
    procedure dbgQueryMouseEnter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure menuConsultaClClick(Sender: TObject);
    procedure menuConsultaFoClick(Sender: TObject);
    procedure menuConsultaFuClick(Sender: TObject);
    procedure menuConsultaIDClick(Sender: TObject);
    procedure menuInsertAltClick(Sender: TObject);
    procedure menuDeleteClick(Sender: TObject);
  private
    procedure saveIDIndex;
  public

  end;

var
   MainFrm: TMainFrm;

implementation

{$R *.lfm}

{ TMainFrm }

procedure TMainFrm.FormResize(Sender: TObject);
begin
  mmJson.Height    := Trunc((Self.Height - (39 + pnlTop.Height)) / 3);
  dbgMemTbl.Height := mmJson.Height;
end;

procedure TMainFrm.menuConsultaClClick(Sender: TObject);
begin
  ZQuery.Active := False;

  ZQuery.Close;
  ZQuery.SQL.Clear;
  ZQuery.SQL.Add('SELECT * FROM pessoa WHERE tipo_pessoa = 0 ORDER BY id');
  ZQuery.Open;

  saveIDIndex;

  ZQuery.Active := True;
  Button3.Enabled := True;
  Button5.Enabled := True;
end;

procedure TMainFrm.menuConsultaFoClick(Sender: TObject);
begin
  ZQuery.Active := False;

  ZQuery.Close;
  ZQuery.SQL.Clear;
  ZQuery.SQL.Add('SELECT * FROM pessoa WHERE tipo_pessoa = 2 ORDER BY id');
  ZQuery.Open;

  saveIDIndex;

  ZQuery.Active := True;
  Button3.Enabled := True;
  Button5.Enabled := True;
end;

procedure TMainFrm.menuConsultaFuClick(Sender: TObject);
begin
  ZQuery.Active := False;

  ZQuery.Close;
  ZQuery.SQL.Clear;
  ZQuery.SQL.Add('SELECT * FROM pessoa WHERE tipo_pessoa = 1 ORDER BY id');
  ZQuery.Open;

  saveIDIndex;

  ZQuery.Active := True;
  Button3.Enabled := True;
  Button5.Enabled := True;
end;

procedure TMainFrm.menuConsultaIDClick(Sender: TObject);
begin
  FrmConsulta.ShowModal;
end;

procedure TMainFrm.menuInsertAltClick(Sender: TObject);
begin
  FrmInsert.ShowModal;
end;

procedure TMainFrm.menuDeleteClick(Sender: TObject);
begin
  FrmDelete.ShowModal;
end;

procedure TMainFrm.saveIDIndex;
var
  i: integer;
begin
  for i := 0 to ZQuery.FieldCount - 1 do
  begin
    if ZQuery.Fields[i].FieldName = 'ID' then
    begin
      dbgQuery.Columns[i].Index := 0;
      Break;
    end;
  end;

end;

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  if not Assigned( DM ) then
     Application.CreateForm(TDM, DM);

  ZQuery.Connection := DM.ZConnection;
  Button3.Enabled := False;
end;

procedure TMainFrm.Button1Click(Sender: TObject);
begin
  Button1.Enabled := False;
  Button5.Enabled := True;

  ZQuery.Active := False;

  ZQuery.Close;
  ZQuery.SQL.Clear;
  ZQuery.SQL.Add('SELECT * FROM pessoa ORDER BY id');
  ZQuery.Open;

  saveIDIndex;

  ZQuery.Active := True;
  Button3.Enabled := True;

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
  Button2.Enabled := True;
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
  Button2.Enabled := True;
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

procedure TMainFrm.Button5Click(Sender: TObject);
begin
  if ZQuery.Active then
  ZQuery.Active := not ZQuery.Active;

  Button1.Enabled := True;
  Button5.Enabled := False;
  Button3.Enabled := False;
end;

procedure TMainFrm.dbgQueryCellClick(Column: TColumn);
var
  aID: string;
  lTpPessoa: integer;
begin
  aID := dbgQuery.DataSource.DataSet.FieldByName('id').AsString;
  FrmConsulta.getID(aID);
  lTpPessoa := DM.GetTpPessoa(StrToInt(aID));
  case lTpPessoa of
      0: FrmConsulta.edtTipo.Text := 'Cliente';
      1: FrmConsulta.edtTipo.Text := 'Funcionário';
      2: FrmConsulta.edtTipo.Text := 'Fornecedor';
    end;

  FrmConsulta.ShowModal;
end;

end.
