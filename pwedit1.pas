unit pwedit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, DBCtrls,
  StdCtrls, ComCtrls, Windows, IniFiles, SQLDB, DB, SQLite3Conn,
  mylibrary, DCPblowfish
  ;

type

  { TfrmEdit }

  TfrmEdit = class(TForm)
    cphUser: TDCP_blowfish;
    edtSiteName: TEdit;
    edtShow: TDBGrid;
    edtURL: TEdit;
    edtAccountName: TEdit;
    edtAccountPass: TEdit;
    edtPassConf: TEdit;
    lblSiteName: TLabel;
    lblURL: TLabel;
    lblAccountName: TLabel;
    lblAccountPass: TLabel;
    lblConfPass: TLabel;
    dbPass: TSQLite3Connection;
    qryEdit: TSQLQuery;
    trxPass: TSQLTransaction;
    srcShow: TDataSource;
    qryShow: TSQLQuery;
    stbEdit: TStatusBar;
    procedure edtShowCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    aConfig          : TIniFile;
    aUserName        : String;
    aUserPass        : String;
    procedure GetThatDamnConfig;
    procedure SetThatDamnConfig;
    procedure FillQuery(aQuery : TSQLQuery; aSentence : String);
    procedure DoSave;
  public

  end;

var
  frmEdit: TfrmEdit;

implementation

{$R *.frm}

{ TfrmEdit }

procedure TfrmEdit.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  dbPass.Connected := false;
  SetThatDamnConfig;
end;

procedure TfrmEdit.edtShowCellClick(Column: TColumn);
begin

end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
//  aConfig := TIniFile.Create(extractfilepath(paramstr(0)) + 'config.ini');
  aUserName := ParamStr(1);
  aConfig := TIniFile.Create('.\config.ini');
  GetThatDamnConfig;
  ActiveControl := edtShow;
  dbPass.Connected := true;
  FillQuery(qryEdit, qry0001);
  qryEdit.ParamByName('aUserName').AsString := aUserName;
  qryEdit.Open;
  if (qryEdit.EOF) then
     begin
     aUserName := 'ERROR!!!';
     aUserPass := '';
     end
  else
     begin
     aUserName := qryEdit.FieldByName('name').AsString;
     aUserPass := qryEdit.FieldByName('newpass').AsString;
     end;
  frmEdit.Caption := 'Password Keeper for ' + aUserName;

  FillQuery(qryShow, qry0002);
  qryShow.ParamByName('aUserName').AsString := aUserName;
  qryShow.Open;

end;

procedure TfrmEdit.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key of
       vk_Escape : begin
                   Close;
                   end;
       vk_S      : begin
                   if (ssCtrl in Shift) then
                      begin
                      DoSave;
                      end;
                   end;
  end;
end;

procedure TfrmEdit.GetThatDamnConfig;
begin
  frmEdit.Left := aConfig.ReadInteger('edit_position', 'left', 0);
  frmEdit.Top := aConfig.ReadInteger('edit_position', 'top', 0);
end;

procedure TfrmEdit.SetThatDamnConfig;
begin
  aConfig.WriteInteger('edit_position', 'left', frmEdit.Left);
  aConfig.WriteInteger('edit_position', 'top', frmEdit.Top);
end;

procedure TfrmEdit.FillQuery(aQuery: TSQLQuery; aSentence: String);
begin
  aQuery.Close;
  aQuery.SQL.Clear;
  aQuery.SQL.Add(aSentence);
end;

procedure TfrmEdit.DoSave;
begin

end;

end.

