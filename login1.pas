unit login1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Windows, IniFiles, Process, SQLDB, SQLite3Conn
  ;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    edtName: TEdit;
    edtPassword: TEdit;
    lblName: TLabel;
    lblPassword: TLabel;
    aProcess: TProcess;
    stbLogin: TStatusBar;
    procedure edtNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure edtPasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    aConfig          : TIniFile;
    procedure GetThatDamnConfig;
    procedure SetThatDamnConfig;
  public

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.frm}

{ TfrmLogin }

procedure TfrmLogin.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Escape : begin
                 Close;
                 end;
     vk_A      : begin  // Ctrl-A edit user
                 if ((ssCtrl in Shift) and (not (ssAlt in Shift)) and (not (ssShift in Shift)))then
                    begin
                    frmLogin.Hide;
                    aProcess.Executable := '.\pwuser.exe';
                    // aProcess.Parameters.Add(edtName.Text);
                    // aProcess.Parameters.Add(edtPassword.Text);
                    aProcess.Execute;
                    frmLogin.Show;
                    end;
                 end;
     vk_D      : begin  // Ctrl-D show password list
                 if ((ssCtrl in Shift) and (not (ssAlt in Shift)) and (not (ssShift in Shift)))then
                    begin
                    frmLogin.Hide;
                    aProcess.Executable := '.\pwedit.exe';
                    aProcess.Parameters.Add(edtName.Text);
                    aProcess.Parameters.Add(edtPassword.Text);
                    aProcess.Execute;
                    frmLogin.Show;
                    end;
                 end;
     end;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
//aConfig := TIniFile.Create(extractfilepath(paramstr(0)) + 'config.ini');
aConfig := TIniFile.Create('.\config.ini');
GetThatDamnConfig;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
SetThatDamnConfig;
aConfig.Free;
end;

procedure TfrmLogin.edtNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
       vk_Return : begin
                   ActiveControl := edtPassword;
                   end;
       vk_Up     : begin
                   ActiveControl := edtPassword;
                   end;
       vk_Down   : begin
                   ActiveControl := edtPassword;
                   end;
       end;
end;

procedure TfrmLogin.edtPasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
case Key of
     vk_Return : begin
                 ActiveControl := edtName
                 end;
     vk_Up     : begin
                 ActiveControl := edtName;
                 end;
     vk_Down   : begin
                 ActiveControl := edtName;
                 end;
     end;
end;

procedure TfrmLogin.GetThatDamnConfig;
begin
frmLogin.Left := aConfig.ReadInteger('login_position', 'left', 0);
frmLogin.Top := aConfig.ReadInteger('login_position', 'top', 0);
end;

procedure TfrmLogin.SetThatDamnConfig;
begin
aConfig.WriteInteger('login_position', 'left', frmLogin.Left);
aConfig.WriteInteger('login_position', 'top', frmLogin.Top);
end;

end.

