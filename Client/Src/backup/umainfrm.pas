unit uMainFrm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, RxDBGrid;

type

  { TMainFrm }

  TMainFrm = class(TForm)
    dsQuery: TDataSource;
    dsMemTbl: TDataSource;
    dbgMemTbl: TDBGrid;
    dbgQuery: TDBGrid;
    mmJson: TMemo;
    pnlTop: TPanel;
    procedure FormResize(Sender: TObject);
  private

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

end.

