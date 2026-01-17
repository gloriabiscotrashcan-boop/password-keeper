object frmMenu: TfrmMenu
  Left = 270
  Height = 178
  Top = 142
  Width = 320
  BorderStyle = bsSingle
  Caption = 'Password keeper - menu'
  ClientHeight = 178
  ClientWidth = 320
  KeyPreview = True
  LCLVersion = '8.8'
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  object btnAdd: TButton
    Left = 96
    Height = 25
    Top = 16
    Width = 120
    Caption = '&Add password'
    TabOrder = 0
    OnClick = btnAddClick
  end
  object btnDelete: TButton
    Left = 96
    Height = 25
    Top = 56
    Width = 120
    Caption = '&Delete password'
    TabOrder = 1
    OnClick = btnDeleteClick
  end
  object btnGet: TButton
    Left = 96
    Height = 25
    Top = 96
    Width = 120
    Caption = '&Get password'
    TabOrder = 2
    OnClick = btnGetClick
  end
  object btnChange: TButton
    Left = 96
    Height = 25
    Top = 136
    Width = 120
    Caption = '&Change password'
    TabOrder = 3
    OnClick = btnChangeClick
  end
  object aProcess: TProcess
    Active = False
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
    Left = 245
    Top = 24
  end
end
