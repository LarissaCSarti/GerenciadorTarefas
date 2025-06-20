object FrmTarefas: TFrmTarefas
  Left = 0
  Top = 0
  Caption = 'Tarefas'
  ClientHeight = 396
  ClientWidth = 757
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlBotoes: TPanel
    Left = 0
    Top = 0
    Width = 757
    Height = 35
    Align = alTop
    TabOrder = 1
    object btnIncluir: TBitBtn
      Left = 1
      Top = 1
      Width = 89
      Height = 33
      Align = alLeft
      Caption = '&Incluir'
      TabOrder = 1
      OnClick = btnIncluirClick
    end
    object btnEditar: TBitBtn
      Left = 90
      Top = 1
      Width = 75
      Height = 33
      Align = alLeft
      Caption = '&Editar'
      TabOrder = 2
      OnClick = btnEditarClick
    end
    object btnCancelar: TBitBtn
      Left = 165
      Top = 1
      Width = 75
      Height = 33
      Align = alLeft
      Caption = '&Cancelar'
      TabOrder = 3
      OnClick = btnCancelarClick
    end
    object btnSalvar: TBitBtn
      Left = 240
      Top = 1
      Width = 75
      Height = 33
      Align = alLeft
      Caption = '&Salvar'
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnExcluir: TBitBtn
      Left = 315
      Top = 1
      Width = 75
      Height = 33
      Align = alLeft
      Caption = '&Excluir'
      TabOrder = 4
      OnClick = btnExcluirClick
    end
  end
  object pnlCampos: TPanel
    Left = 0
    Top = 35
    Width = 757
    Height = 224
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 88
      Top = 8
      Width = 37
      Height = 13
      Caption = 'C'#243'digo:'
    end
    object Label2: TLabel
      Left = 75
      Top = 35
      Width = 50
      Height = 13
      Caption = 'Descri'#231#227'o:'
    end
    object Label3: TLabel
      Left = 59
      Top = 61
      Width = 66
      Height = 13
      Caption = 'Data Cria'#231#227'o:'
    end
    object Label4: TLabel
      Left = 46
      Top = 89
      Width = 79
      Height = 13
      Caption = 'Usu'#225'rio Cria'#231#227'o:'
    end
    object Label5: TLabel
      Left = 73
      Top = 117
      Width = 52
      Height = 13
      Caption = 'Prioridade:'
    end
    object Label6: TLabel
      Left = 33
      Top = 167
      Width = 92
      Height = 13
      Caption = 'Usu'#225'rio Conclus'#227'o:'
    end
    object Label7: TLabel
      Left = 11
      Top = 194
      Width = 114
      Height = 13
      Caption = 'Observa'#231#227'o Conclus'#227'o:'
    end
    object edtcodigo: TEdit
      Left = 131
      Top = 5
      Width = 79
      Height = 21
      Enabled = False
      TabOrder = 0
    end
    object edtdescricao: TEdit
      Left = 131
      Top = 32
      Width = 379
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 255
      TabOrder = 1
    end
    object edtusuario_criacao: TEdit
      Left = 131
      Top = 86
      Width = 211
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 45
      TabOrder = 3
    end
    object edtprioridade: TEdit
      Left = 131
      Top = 114
      Width = 79
      Height = 21
      NumbersOnly = True
      TabOrder = 4
    end
    object edtusuario_conclusao: TEdit
      Left = 131
      Top = 164
      Width = 211
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 45
      TabOrder = 6
    end
    object edtdata_hora_criacao: TDateTimePicker
      Left = 131
      Top = 59
      Width = 171
      Height = 21
      Date = 45827.000000000000000000
      Time = 0.754761597221659000
      Enabled = False
      TabOrder = 2
    end
    object edtconcluir: TCheckBox
      Left = 131
      Top = 141
      Width = 97
      Height = 17
      Caption = 'Concluir Tarefa?'
      TabOrder = 5
    end
    object edtobservacao: TEdit
      Left = 131
      Top = 191
      Width = 379
      Height = 21
      CharCase = ecUpperCase
      MaxLength = 2048
      TabOrder = 7
    end
    object gbEstatisticas: TGroupBox
      Left = 516
      Top = 1
      Width = 240
      Height = 222
      Align = alRight
      Caption = 'Estatisticas'
      TabOrder = 8
      object lblTotal: TLabel
        Left = 7
        Top = 40
        Width = 103
        Height = 13
        Caption = 'Total de Tarefas: %d'
      end
      object lblMedia: TLabel
        Left = 7
        Top = 88
        Width = 212
        Height = 13
        Caption = 'M'#233'dia de Prioridade Tarefas Pend'#234'ntes: %d'
      end
      object lblTotalConcluido: TLabel
        Left = 7
        Top = 141
        Width = 209
        Height = 13
        Caption = 'Qtd. Tarefas Conclu'#237'das Ultimos 7 Dias: %d'
      end
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 259
    Width = 757
    Height = 137
    Align = alClient
    TabOrder = 2
    object GridTarefas: TDBGrid
      Left = 1
      Top = 1
      Width = 755
      Height = 135
      Align = alClient
      DataSource = dsTarefas
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'codigo'
          Title.Caption = 'C'#243'digo'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'descricao'
          Title.Caption = 'Descri'#231#227'o'
          Width = 400
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'data_hora_criacao'
          Title.Caption = 'Data Cria'#231#227'o'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'usuario_criacao'
          Title.Caption = 'Usu'#225'rio Cria'#231#227'o'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'prioridade'
          Title.Caption = 'Prioridade'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'data_hora_conclusao'
          Title.Caption = 'Data Conclus'#227'o'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'usuario_conclusao'
          Title.Caption = 'Usu'#225'rio Conclus'#227'o'
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'observacao'
          Title.Caption = 'Observa'#231#227'o Conclus'#227'o'
          Width = 400
          Visible = True
        end>
    end
  end
  object memTarefas: TFDMemTable
    AfterScroll = memTarefasAfterScroll
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 656
    Top = 24
    object memTarefascodigo: TIntegerField
      FieldName = 'codigo'
    end
    object memTarefasdescricao: TStringField
      FieldName = 'descricao'
      Size = 255
    end
    object memTarefasdata_hora_criacao: TDateTimeField
      FieldName = 'data_hora_criacao'
    end
    object memTarefasusuario_criacao: TStringField
      FieldName = 'usuario_criacao'
      Size = 45
    end
    object memTarefasprioridade: TIntegerField
      FieldName = 'prioridade'
    end
    object memTarefasdata_hora_conclusao: TDateTimeField
      FieldName = 'data_hora_conclusao'
    end
    object memTarefasusuario_conclusao: TStringField
      FieldName = 'usuario_conclusao'
      Size = 45
    end
    object memTarefasobservacao: TStringField
      FieldName = 'observacao'
      Size = 2048
    end
  end
  object dsTarefas: TDataSource
    AutoEdit = False
    DataSet = memTarefas
    Left = 656
    Top = 72
  end
end
