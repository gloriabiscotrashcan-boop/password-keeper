unit pwuser1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  DCPblowfish, Windows, IniFiles, SQLDB, SQLite3Conn,
  mylibrary
  ;


type

  { TfrmUser }

  TfrmUser = class(TForm)
    btnSave: TButton;
    cphUser: TDCP_blowfish;
    edtUserName: TEdit;
    edtUserPass: TEdit;
    dbUser: TSQLite3Connection;
    lblOldPass: TLabel;
    qryUser: TSQLQuery;
    edtPassConf: TEdit;
    lblUserName: TLabel;
    lblUserPass: TLabel;
    lblPassConf: TLabel;
    edtOldPass: TEdit;
    trxUser: TSQLTransaction;
    stbUser: TStatusBar;
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveEnter(Sender: TObject);
    procedure btnSaveKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtOldPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtPassConfKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtUserNameEnter(Sender: TObject);
    procedure edtUserNameExit(Sender: TObject);
    procedure edtOldPassEnter(Sender: TObject);
    procedure edtPassConfEnter(Sender: TObject);
    procedure edtUserNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtUserPassEnter(Sender: TObject);
    procedure edtUserPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    aConfig     : TIniFile;
    aOldPass    : String;
    aUserExists : Boolean;
    procedure GetThatDamnConfig;
    procedure SetThatDamnConfig;
    procedure FillQuery(aQuery : TSQLQuery; aSentence : String);
    function UserExists(aUserName : String) : Boolean;
    procedure DoSave;
  public

  end;

var
  frmUser: TfrmUser;

implementation

{$R *.frm}

{ TfrmUser }

procedure TfrmUser.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
SetThatDamnConfig;
aConfig.Free;
qryUser.Close;
trxUser.Active := false;
dbUser.Connected := false;
end;

procedure TfrmUser.edtUserNameExit(Sender: TObject);
begin
aUserExists := UserExists(edtUserName.Text);
if (aUserExists) then
   begin
   aOldPass := qryUser.FieldByName('newpass').AsString;
   edtOldPass.Enabled := true;
   ActiveControl := edtOldPass;
   end
else
   begin
   aOldPass := '';
   edtOldPass.Enabled := false;
   ActiveControl := edtUserPass;
   end;
end;

procedure TfrmUser.edtOldPassEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Enter current password to change; Alt-S to save';
end;

procedure TfrmUser.edtPassConfEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Password confirmation; Alt-S to save';
end;

procedure TfrmUser.edtUserNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
       vk_Up     : begin
                   ActiveControl := btnSave;
                   end;
       vk_Down   : begin
                   if (edtOldPass.Enabled) then
                      begin
                      ActiveControl := edtOldPass;
                      end
                   else
                      begin
                      ActiveControl := edtUserPass;
                      end;
                   end;
       vk_Return : begin
                   if (edtOldPass.Enabled) then
                      begin
                      ActiveControl := edtOldPass;
                      end
                   else
                      begin
                      ActiveControl := edtUserPass;
                      end;
                   end;
       end;
end;

procedure TfrmUser.edtUserPassEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Enter password; Alt-S to save';
end;

procedure TfrmUser.edtUserPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 if (edtOldPass.Enabled) then
                    begin
                    ActiveControl := edtOldPass;
                    end
                 else
                    begin
                    ActiveControl := edtUserName;
                    end;
                 end;
     vk_Down   : begin
                 ActiveControl := edtPassConf;
                 end;
     vk_Return : begin
                 ActiveControl := edtPassConf;
                 end;
     end;
end;

procedure TfrmUser.edtUserNameEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Enter user name; Alt-S to save';
end;

procedure TfrmUser.btnSaveEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Click / press to save';
end;

procedure TfrmUser.btnSaveKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 ActiveControl := edtPassConf;
                 end;
     vk_Down   : begin
                 ActiveControl := edtUserName;
                 end;
     end;

end;

procedure TfrmUser.edtOldPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 ActiveControl := edtUserName;
                 end;
     vk_Down   : begin
                 ActiveControl := edtUserPass;
                 end;
     vk_Return : begin
                 ActiveControl := edtUserPass;
                 end;
     end;

end;

procedure TfrmUser.edtPassConfKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 ActiveControl := edtUserPass;
                 end;
     vk_Down   : begin
                 ActiveControl := btnSave;
                 end;
     vk_Return : begin
                 ActiveControl := btnSave;
                 end;
     end;

end;

procedure TfrmUser.btnSaveClick(Sender: TObject);
begin
DoSave;
end;

procedure TfrmUser.FormCreate(Sender: TObject);
begin
aConfig := TIniFile.Create('.\config.ini');
GetThatDamnConfig;
dbUser.Connected := true;
//edtUserName.Text := Trim(ParamStr(1));
//edtUserPass.Text := Trim(ParamStr(2));
edtOldPass.Enabled := false;
dbUser.Connected := true;
trxUser.Active := true;
end;

procedure TfrmUser.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  case Key Of
       vk_Escape : begin
                   Close;
                   end;
       vk_S      : begin
                   if ssAlt in Shift then
                      begin
                      DoSave;
                      end;
                   end;
  end;
end;

procedure TfrmUser.GetThatDamnConfig;
begin
frmUser.Left := aConfig.ReadInteger('user_position', 'left', 0);
frmUser.Top := aConfig.ReadInteger('user_position', 'top', 0);
end;

procedure TfrmUser.SetThatDamnConfig;
begin
aConfig.WriteInteger('user_position', 'left', frmUser.Left);
aConfig.WriteInteger('user_position', 'top', frmUser.Top);
end;

procedure TfrmUser.FillQuery(aQuery: TSQLQuery; aSentence: String);
begin
aQuery.Close;
aQuery.SQL.Clear;
aQuery.SQL.Add(aSentence);
end;

function TfrmUser.UserExists(aUserName: String): Boolean;
begin
// qry0001 = 'select * from owner where name = :aUserName';
FillQuery(qryUser, qry0001);
qryUser.ParamByName('ausername').AsString := Trim(edtUserName.Text);
qryUser.Open;
if (qryUser.EOF) then
   begin
   Result := false;
   end
else
   begin
   Result := true;
   end;
end;

procedure TfrmUser.DoSave;
var aNewPass  : String;
    xOldPass  : String;
begin
if (Trim(edtUserPass.Text) <> Trim(edtPassConf.Text)) then
   begin
   ShowMessage('Password and confirmation does not match.');
   ActiveControl := edtUserPass;
   Exit;
   end;

xOldPass := UserPassMaker(Trim(edtOldPass.Text));
aNewPass := UserPassMaker(Trim(edtUserPass.Text));

if (aUserExists) then
   begin
   if (aOldPass <> xOldPass) then
      begin
      ShowMessage('Old password does not match.');
      ActiveControl := edtOldPass;
      Exit;
      end
   else
      begin
//      qry0011 = 'update owner set oldpass = :aoldpass where name = :ausername';
//      qry0012 = 'update owner set newpass = :anewpass where name = :ausername';
      FillQuery(qryUser, qry0011);
      qryUser.ParamByName('aoldpass').AsString := xOldPass;
      qryUser.ParamByName('ausername').AsString := Trim(edtUserName.Text);
      qryUser.ExecSQL;
      FillQuery(qryUser, qry0012);
      qryUser.ParamByName('ausername').AsString := Trim(edtUserName.Text);
      qryUser.ParamByName('anewpass').AsString := aNewPass;
      qryUser.ExecSQL;

// change the site password list here

      trxUser.Commit;
      end;
   end
else
   begin
//   qry0021 = 'insert into owner (name, oldpass, newpass) values (:ausername, :aoldpass, :anewpass)';
   FillQuery(qryUser, qry0021);
   qryUser.ParamByName('ausername').AsString := Trim(edtUserName.Text);
   qryUser.ParamByName('aoldpass').AsString := aNewPass;
   qryUser.ParamByName('anewpass').AsString := aNewPass;
   qryUser.ExecSQL;
   trxUser.Commit;
   end;
ActiveControl := edtUserName;
end;

end.

