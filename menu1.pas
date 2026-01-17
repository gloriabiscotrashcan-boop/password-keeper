unit menu1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Windows, IniFiles, process
  ;

type

  { TfrmMenu }

  TfrmMenu = class(TForm)
    btnAdd: TButton;
    btnDelete: TButton;
    btnGet: TButton;
    aProcess: TProcess;
    btnChange: TButton;
    procedure btnAddClick(Sender: TObject);
    procedure btnChangeClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnGetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    aConfig : TInifile;
    procedure GetThatDamnConfig;
    procedure SetThatDamnConfig;
  public

  end;

var
  frmMenu: TfrmMenu;

implementation

{$R *.frm}

{ TfrmMenu }

procedure TfrmMenu.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
       vk_Escape : begin
                   Close;
                   end;
  end;
end;

procedure TfrmMenu.GetThatDamnConfig;
begin
  frmMenu.Left := aConfig.ReadInteger('menu_position', 'left', 0);
  frmMenu.Top := aConfig.ReadInteger('menu_position', 'top', 0);
end;

procedure TfrmMenu.SetThatDamnConfig;
begin
  aConfig.WriteInteger('menu_position', 'left', frmMenu.Left);
  aConfig.WriteInteger('menu_position', 'top', frmMenu.Top);
end;

procedure TfrmMenu.btnAddClick(Sender: TObject);
begin
  frmMenu.Hide;
  aProcess.Executable := '.\pwadd.exe';
  aProcess.Execute;
  frmMenu.Show;
end;

procedure TfrmMenu.btnChangeClick(Sender: TObject);
begin
  frmMenu.Hide;
  aProcess.Executable := '.\pwchange.exe';
  aProcess.Execute;
  frmMenu.Show;
end;

procedure TfrmMenu.btnDeleteClick(Sender: TObject);
begin
  frmMenu.Hide;
  aProcess.Executable := '.\pwdelete.exe';
  aProcess.Execute;
  frmMenu.Show;
end;

procedure TfrmMenu.btnGetClick(Sender: TObject);
begin
  frmMenu.Hide;
  aProcess.Executable := '.\pwget.exe';
  aProcess.Execute;
  frmMenu.Show;
end;

procedure TfrmMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  SetThatDamnConfig;
end;

procedure TfrmMenu.FormCreate(Sender: TObject);
begin
  //aConfig := TIniFile.Create(extractfilepath(paramstr(0)) + 'config.ini');
  aConfig := TIniFile.Create('.\config.ini');
  GetThatDamnConfig;
  aProcess.Parameters.Add(ParamStr(1));
  aProcess.Parameters.Add(ParamStr(2));
end;

end.

