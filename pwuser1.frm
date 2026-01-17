object frmUser: TfrmUser
  Left = 270
  Height = 172
  Top = 142
  Width = 476
  BorderStyle = bsSingle
  Caption = 'Password keeper - user'
  ClientHeight = 172
  ClientWidth = 476
  KeyPreview = True
  LCLVersion = '8.8'
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  object lblUserName: TLabel
    Left = 8
    Height = 15
    Top = 8
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Name :'
  end
  object lblUserPass: TLabel
    Left = 8
    Height = 15
    Top = 68
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Password :'
  end
  object lblPassConf: TLabel
    Left = 8
    Height = 15
    Top = 96
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Confirmation :'
  end
  object edtUserName: TEdit
    Left = 96
    Height = 23
    Top = 4
    Width = 120
    TabOrder = 0
    OnEnter = edtUserNameEnter
    OnExit = edtUserNameExit
    OnKeyDown = edtUserNameKeyDown
  end
  object edtUserPass: TEdit
    Left = 96
    Height = 23
    Top = 64
    Width = 300
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 2
    OnEnter = edtUserPassEnter
    OnKeyDown = edtUserPassKeyDown
  end
  object edtPassConf: TEdit
    Left = 96
    Height = 23
    Top = 92
    Width = 300
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 3
    OnEnter = edtPassConfEnter
    OnKeyDown = edtPassConfKeyDown
  end
  object lblOldPass: TLabel
    Left = 8
    Height = 15
    Top = 36
    Width = 80
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Old password :'
    ParentFont = False
  end
  object edtOldPass: TEdit
    Left = 96
    Height = 23
    Top = 32
    Width = 300
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 1
    OnEnter = edtOldPassEnter
    OnKeyDown = edtOldPassKeyDown
  end
  object btnSave: TButton
    Left = 96
    Height = 25
    Top = 118
    Width = 75
    Caption = '&Save'
    TabOrder = 4
    OnClick = btnSaveClick
    OnEnter = btnSaveEnter
    OnKeyDown = btnSaveKeyDown
  end
  object stbUser: TStatusBar
    Left = 0
    Height = 23
    Top = 149
    Width = 476
    Panels = <>
  end
  object qryUser: TSQLQuery
    FieldDefs = <>
    Database = dbUser
    Transaction = trxUser
    Left = 378
    Top = 15
  end
  object dbUser: TSQLite3Connection
    Connected = False
    LoginPrompt = False
    DatabaseName = 'pass'
    KeepConnection = False
    Transaction = trxUser
    AlwaysUseBigint = False
    Left = 378
    Top = 64
  end
  object trxUser: TSQLTransaction
    Active = False
    Action = caNone
    Database = dbUser
    Left = 430
    Top = 64
  end
  object cphUser: TDCP_blowfish
    Id = 5
    Algorithm = 'Blowfish'
    MaxKeySize = 448
    BlockSize = 64
    Left = 252
    Top = 19
  end
end
