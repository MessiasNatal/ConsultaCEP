inherited ViewFontePagadora: TViewFontePagadora
  Caption = 'Fonte Pagadora'
  ClientHeight = 428
  ClientWidth = 759
  ExplicitWidth = 771
  ExplicitHeight = 466
  TextHeight = 13
  inherited pnlPrincipal: TPanel
    Width = 759
    Height = 428
    ExplicitWidth = 735
    ExplicitHeight = 407
    inherited pnlOperacoes: TPanel
      Width = 759
      ExplicitWidth = 735
      inherited btnFechar: TBitBtn
        Left = 699
        ExplicitLeft = 675
      end
      inherited pnlFiltro: TPanel
        Width = 519
        ExplicitWidth = 495
        inherited lblPesquisa: TLabel
          Top = 12
          Width = 30
          Caption = 'Nome'
          ExplicitTop = 12
          ExplicitWidth = 30
        end
        inherited btnPesquisar: TBitBtn
          Height = 23
          ExplicitHeight = 23
        end
        inherited edtPesquisa: TEdit
          Top = 27
          ExplicitTop = 27
        end
      end
    end
    inherited pnlInfo: TPanel
      Top = 404
      Width = 759
      TabOrder = 2
      ExplicitTop = 383
      ExplicitWidth = 735
      inherited lblQtdRegistro: TLabel
        Left = 705
        Height = 16
        ExplicitLeft = 685
      end
      inherited lbOrdenacao: TLabel
        Left = 696
        Height = 18
        ExplicitLeft = 676
      end
    end
    inherited grdRegistros: TDBGrid
      Width = 759
      Height = 352
      TabOrder = 1
      Columns = <
        item
          Expanded = False
          FieldName = 'ID_FONTE_PAGADORA'
          Width = 33
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NOME'
          Width = 144
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DOCUMENTO'
          Width = 101
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CEP'
          Width = 67
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LOGRADOURO'
          Width = 165
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NUMERO'
          Width = 54
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPLEMENTO'
          Width = 133
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BAIRRO'
          Width = 125
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LOCALIDADE'
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UF'
          Width = 35
          Visible = True
        end>
    end
  end
  inherited ActionList: TActionList
    Left = 40
    inherited actPesquisar: TAction
      OnExecute = actPesquisarExecute
    end
  end
  inherited dsPadrao: TDataSource
    Left = 40
  end
  inherited ImgList: TImageList
    Left = 40
  end
end
