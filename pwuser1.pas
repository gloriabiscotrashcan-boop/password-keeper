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
    edtOwnerName: TEdit;
    edtNewPass: TEdit;
    dbUser: TSQLite3Connection;
    lblOldPass: TLabel;
    qrySite: TSQLQuery;
    qryUser: TSQLQuery;
    edtConfPass: TEdit;
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
    procedure edtConfPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtOwnerNameEnter(Sender: TObject);
    procedure edtOwnerNameExit(Sender: TObject);
    procedure edtOldPassEnter(Sender: TObject);
    procedure edtConfPassEnter(Sender: TObject);
    procedure edtOwnerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtNewPassEnter(Sender: TObject);
    procedure edtNewPassKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    aConfig       : TIniFile;
    aOwnerOldPass : String;
    bOwnerExists   : Boolean;
    procedure GetThatDamnConfig;
    procedure SetThatDamnConfig;
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
qrySite.Close;
trxUser.Active := false;
dbUser.Connected := false;
end;

procedure TfrmUser.edtOwnerNameExit(Sender: TObject);
begin
bOwnerExists := UserExists(edtOwnerName.Text);
if (bOwnerExists) then
   begin
   aOwnerOldPass := qryUser.FieldByName('newpass').AsString;
   edtOldPass.Enabled := true;
   ActiveControl := edtOldPass;
   end
else
   begin
   aOwnerOldPass := '';
   edtOldPass.Enabled := false;
   ActiveControl := edtNewPass;
   end;
end;

procedure TfrmUser.edtOldPassEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Enter current password to change; Alt-S to save';
end;

procedure TfrmUser.edtConfPassEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Password confirmation; Alt-S to save';
end;

procedure TfrmUser.edtOwnerNameKeyDown(Sender: TObject; var Key: Word;
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
                      ActiveControl := edtNewPass;
                      end;
                   end;
       vk_Return : begin
                   if (edtOldPass.Enabled) then
                      begin
                      ActiveControl := edtOldPass;
                      end
                   else
                      begin
                      ActiveControl := edtNewPass;
                      end;
                   end;
       end;
end;

procedure TfrmUser.edtNewPassEnter(Sender: TObject);
begin
stbUser.SimpleText := 'Enter password; Alt-S to save';
end;

procedure TfrmUser.edtNewPassKeyDown(Sender: TObject; var Key: Word;
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
                    ActiveControl := edtOwnerName;
                    end;
                 end;
     vk_Down   : begin
                 ActiveControl := edtConfPass;
                 end;
     vk_Return : begin
                 ActiveControl := edtConfPass;
                 end;
     end;
end;

procedure TfrmUser.edtOwnerNameEnter(Sender: TObject);
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
                 ActiveControl := edtConfPass;
                 end;
     vk_Down   : begin
                 ActiveControl := edtOwnerName;
                 end;
     end;

end;

procedure TfrmUser.edtOldPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 ActiveControl := edtOwnerName;
                 end;
     vk_Down   : begin
                 ActiveControl := edtNewPass;
                 end;
     vk_Return : begin
                 ActiveControl := edtNewPass;
                 end;
     end;

end;

procedure TfrmUser.edtConfPassKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Up     : begin
                 ActiveControl := edtNewPass;
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
//edtOwnerName.Text := Trim(ParamStr(1));
//edtNewPass.Text := Trim(ParamStr(2));
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

function TfrmUser.UserExists(aUserName: String): Boolean;
begin
// qry0001 = 'select * from owner where name = :aownername';
FillQuery(qryUser, qry0001);
qryUser.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
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
var aOwnerNewPass : String;
    xOwnerOldPass : String;
    aSiteName     : String;
    aUserName     : String;
    aUserOldPass  : String;
    aUserNewPass  : String;
begin
if (Trim(edtNewPass.Text) <> Trim(edtConfPass.Text)) then
   begin
   ShowMessage('Password and confirmation does not match.');
   ActiveControl := edtNewPass;
   Exit;
   end;

xOwnerOldPass := OwnerPassMaker(Trim(edtOldPass.Text));
aOwnerNewPass := OwnerPassMaker(Trim(edtNewPass.Text));

if (bOwnerExists) then
   begin
   // if old owner exist
   if (aOwnerOldPass <> xOwnerOldPass) then
      begin
      ShowMessage('Old password does not match.');
      ActiveControl := edtOldPass;
      Exit;
      end
   else
      begin
//      qry0011 = 'update owner set oldpass = :aoldpass where name = :aownername';
      FillQuery(qryUser, qry0011);
      qryUser.ParamByName('aoldpass').AsString := xOwnerOldPass;
      qryUser.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
      qryUser.ExecSQL;
//      qry0012 = 'update owner set newpass = :anewpass where name = :aownername';
      FillQuery(qryUser, qry0012);
      qryUser.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
      qryUser.ParamByName('anewpass').AsString := aOwnerNewPass;
      qryUser.ExecSQL;

// change to owner pass reflected to the site password list
// qry0002 = 'select * from password where owner = :aownername';
      FillQuery(qryUser, qry0002);
      qryUser.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
      qryUser.Open;
      qryUser.First;
      while not(qryUser.EOF) do
            begin
            aUserName := qryUser.FieldByName('username').AsString;
            aSiteName := qryUser.FieldByName('site').AsString;
            aUserOldPass := SitePassReader(Trim(edtOldPass.Text), qryUser.FieldByName('userpass').AsString, aUserName);
            aUserNewPass := SitePassMaker(Trim(edtNewPass.Text), aUserOldPass, aUserName);
//            qry0031 = 'update password set userpass = :auserpass where username = :ausername and asite = :asite and owner = :aownername';
            FillQuery(qrySite, qry0031);
            qrySite.ParamByName('auserpass').AsString := aUserNewPass;
            qrySite.ParamByName('ausername').AsString := aUserName;
            qrySite.ParamByName('asite').AsString := aSiteName;
            qrySite.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
            qrySite.ExecSQL;

            qryUser.Next;
            end;
      trxUser.Commit;
      end;
   end
else
   begin
//   qry0021 = 'insert into owner (name, oldpass, newpass) values (:aownername, :aoldpass, :anewpass)';
   FillQuery(qryUser, qry0021);
   qryUser.ParamByName('aownername').AsString := Trim(edtOwnerName.Text);
   qryUser.ParamByName('aoldpass').AsString := aOwnerNewPass;
   qryUser.ParamByName('anewpass').AsString := aOwnerNewPass;
   qryUser.ExecSQL;
   trxUser.Commit;
   end;
ActiveControl := edtOwnerName;
end;

end.

