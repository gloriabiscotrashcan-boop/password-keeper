object frmLogin: TfrmLogin
  Left = 270
  Height = 82
  Top = 142
  Width = 320
  BorderStyle = bsSingle
  Caption = 'Password keeper - login'
  ClientHeight = 82
  ClientWidth = 320
  KeyPreview = True
  LCLVersion = '8.8'
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  object lblName: TLabel
    Left = 8
    Height = 15
    Top = 8
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'User name :'
  end
  object lblPassword: TLabel
    Left = 8
    Height = 15
    Top = 32
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Password :'
  end
  object edtName: TEdit
    Left = 96
    Height = 23
    Top = 4
    Width = 200
    TabOrder = 0
    OnKeyDown = edtNameKeyDown
  end
  object edtPassword: TEdit
    Left = 96
    Height = 23
    Top = 29
    Width = 200
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = edtPasswordKeyDown
  end
  object stbLogin: TStatusBar
    Left = 0
    Height = 23
    Top = 59
    Width = 320
    Panels = <>
    SimpleText = 'Ctrl-A to edit user; Ctrl-D to show password list'
  end
  object aProcess: TProcess
    Active = False
    Executable = 'menu.exe'
    Options = [poWaitOnExit]
    Priority = ppNormal
    StartupOptions = []
    ShowWindow = swoNone
    SkipCommandLineQuotes = False
    WindowColumns = 0
    WindowHeight = 0
    WindowLeft = 0
    WindowRows = 0
    WindowTop = 0
    WindowWidth = 0
    FillAttribute = 0
    InputDescriptor.IOType = iotDefault
    InputDescriptor.FileWriteMode = fwmTruncate
    OutputDescriptor.IOType = iotDefault
    OutputDescriptor.FileWriteMode = fwmTruncate
    ErrorDescriptor.IOType = iotDefault
    ErrorDescriptor.FileWriteMode = fwmTruncate
    Left = 280
    Top = 8
  end
end
