object frmEdit: TfrmEdit
  Left = 270
  Height = 436
  Top = 142
  Width = 798
  BorderStyle = bsSingle
  Caption = 'Password Keeper - edit'
  ClientHeight = 436
  ClientWidth = 798
  KeyPreview = True
  LCLVersion = '8.8'
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  object lblSiteName: TLabel
    Left = 8
    Height = 15
    Top = 268
    Width = 100
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Site name :'
  end
  object lblURL: TLabel
    Left = 8
    Height = 15
    Top = 296
    Width = 100
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Site url :'
  end
  object lblAccountName: TLabel
    Left = 8
    Height = 15
    Top = 324
    Width = 100
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Account :'
  end
  object lblAccountPass: TLabel
    Left = 8
    Height = 15
    Top = 352
    Width = 100
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'New password :'
  end
  object lblConfPass: TLabel
    Left = 8
    Height = 15
    Top = 380
    Width = 100
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'Confirm :'
  end
  object edtShow: TDBGrid
    Left = 8
    Height = 252
    Top = 8
    Width = 784
    Color = clWindow
    Columns = <    
      item
        Title.Caption = 'Site name'
        Width = 200
        FieldName = 'site'
      end    
      item
        Title.Caption = 'URL'
        Width = 443
        FieldName = 'url'
      end    
      item
        Title.Caption = 'Account'
        Width = 120
        FieldName = 'username'
      end>
    DataSource = srcShow
    FixedCols = 0
    Options = [dgTitles, dgColumnResize, dgColumnMove, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    ReadOnly = True
    TabOrder = 0
    OnCellClick = edtShowCellClick
  end
  object stbEdit: TStatusBar
    Left = 0
    Height = 23
    Top = 413
    Width = 798
    Panels = <>
    SimpleText = 'Click from the list to copy password to clipboard; Ctrl-S to save new password'
  end
  object edtSiteName: TEdit
    Left = 112
    Height = 23
    Top = 264
    Width = 200
    TabOrder = 1
  end
  object edtURL: TEdit
    Left = 112
    Height = 23
    Top = 292
    Width = 450
    TabOrder = 2
  end
  object edtAccountName: TEdit
    Left = 112
    Height = 23
    Top = 320
    Width = 200
    TabOrder = 3
  end
  object edtAccountPass: TEdit
    Left = 112
    Height = 23
    Top = 348
    Width = 200
    TabOrder = 4
  end
  object edtPassConf: TEdit
    Left = 112
    Height = 23
    Top = 376
    Width = 200
    TabOrder = 5
  end
  object qryShow: TSQLQuery
    FieldDefs = <>
    Database = dbPass
    Transaction = trxPass
    Left = 104
    Top = 156
  end
  object srcShow: TDataSource
    DataSet = qryShow
    Left = 160
    Top = 156
  end
  object dbPass: TSQLite3Connection
    Connected = False
    LoginPrompt = False
    DatabaseName = 'pass'
    KeepConnection = False
    Transaction = trxPass
    AlwaysUseBigint = False
    Left = 48
    Top = 120
  end
  object qryEdit: TSQLQuery
    FieldDefs = <>
    Database = dbPass
    Transaction = trxPass
    Left = 104
    Top = 120
  end
  object cphUser: TDCP_blowfish
    Id = 5
    Algorithm = 'Blowfish'
    MaxKeySize = 448
    BlockSize = 64
    Left = 403
    Top = 199
  end
  object trxPass: TSQLTransaction
    Active = False
    Database = dbPass
    Left = 160
    Top = 120
  end
end
