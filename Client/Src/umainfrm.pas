unit uMainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, RxDBGrid, ZDataset;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    dsQuery: TDataSource;
    dsMemTbl: TDataSource;
    dbgMemTbl: TDBGrid;
    dbgQuery: TDBGrid;
    mmJson: TMemo;
    pnlTop: TPanel;
    ZQuery: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
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

end.

