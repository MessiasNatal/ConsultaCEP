inherited ViewConsultaCEP: TViewConsultaCEP
  Caption = 'Pesquisa de CEP'
  ClientHeight = 507
  ClientWidth = 976
  ExplicitWidth = 988
  ExplicitHeight = 545
  TextHeight = 13
  object pnlPrincipal: TPanel [0]
    Left = 0
    Top = 0
    Width = 976
    Height = 507
    Align = alClient
    TabOrder = 0
    ExplicitWidth = 972
    ExplicitHeight = 506
    object pnlFiltro: TPanel
      Left = 1
      Top = 1
      Width = 974
      Height = 55
      Align = alTop
      TabOrder = 0
      ExplicitWidth = 970
      object rgTipoRetorno: TRadioGroup
        AlignWithMargins = True
        Left = 144
        Top = 4
        Width = 110
        Height = 47
        Align = alLeft
        Caption = ' Tipo de Retorno '
        Columns = 2
        ItemIndex = 0
        Items.Strings = (
          'JSON'
          'XML')
        TabOrder = 1
      end
      object gbConsultaEndereco: TGroupBox
        AlignWithMargins = True
        Left = 370
        Top = 4
        Width = 498
        Height = 47
        Align = alLeft
        Caption = ' Consulta por Endere'#231'o '
        TabOrder = 3
        object lbEstado: TLabel
          Left = 8
          Top = 22
          Width = 37
          Height = 13
          Caption = 'Estado:'
        end
        object lbLocalidade: TLabel
          Left = 123
          Top = 22
          Width = 54
          Height = 13
          Caption = 'Localidade:'
        end
        object lbLogradouro: TLabel
          Left = 299
          Top = 22
          Width = 59
          Height = 13
          Caption = 'Logradouro:'
        end
        object edtLogradouro: TEdit
          Left = 364
          Top = 19
          Width = 113
          Height = 21
          TabOrder = 2
          OnChange = edtConsultaEnderecoChange
        end
        object edtLocalidade: TEdit
          Left = 180
          Top = 19
          Width = 113
          Height = 21
          TabOrder = 1
          OnChange = edtConsultaEnderecoChange
        end
        object cbUF: TComboBox
          Left = 46
          Top = 19
          Width = 71
          Height = 21
          Style = csDropDownList
          TabOrder = 0
          OnChange = edtConsultaEnderecoChange
          Items.Strings = (
            'AC'
            'AL'
            'AP'
            'AM'
            'BA'
            'CE'
            'DF'
            'ES'
            'GO'
            'MA'
            'MT'
            'MS'
            'MG'
            'PA'
            'PB'
            'PR'
            'PE'
            'PI'
            'RJ'
            'RN'
            'RS'
            'RO'
            'RR'
            'SC'
            'SP'
            'SE'
            'TO')
        end
      end
      object gbConsultaCEP: TGroupBox
        AlignWithMargins = True
        Left = 260
        Top = 4
        Width = 104
        Height = 47
        Align = alLeft
        Caption = ' Consulta por CEP '
        TabOrder = 2
        object edtConsultaCEP: TEdit
          Left = 8
          Top = 19
          Width = 87
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          OnChange = edtConsultaCEPChange
          OnClick = edtConsultaCEPClick
        end
      end
      object btnPesquisar: TBitBtn
        AlignWithMargins = True
        Left = 874
        Top = 11
        Width = 96
        Height = 40
        Cursor = crHandPoint
        Margins.Top = 10
        Align = alLeft
        Caption = 'Pesquisar'
        Glyph.Data = {
          36050000424D3605000000000000360400002800000010000000100000000100
          080000000000000100000000000000000000000100000000000000000000FFFF
          FF00AF786800AF796800AF786600AF776500AE756300AA726000FF00FF00AF77
          6700DBBAAB00FAF2EB00FCF5EF00FCF1E900F3E1D500CA9E8800AB725C00AF77
          6400EFDBCF00FCF4EC00F6E5D400F0DAC500ECCBB000E9C3A200F0D7BF00D7B2
          9A00A96E5700AF766300D6B19F00FAEEE400F5E2D000F9EFE700F8EEE300EFD5
          BB00E7BB9400E0AA7A00F0CFB400C3937A009A614C00AE735E00F4E4D700EDD1
          B500F8EBE000FFFEFD00FBF3ED00EED5BE00E3B48B00E1A67000E6AB7900EBD1
          BE00A8684F00AE715B00F5DFCD00EBC5A500FBF4ED00F4E3D500E5C2A200DDA8
          7700E2AB7800E6AC7800F5E1D000AB684C00AD6F5700EFD0B500E6AF8000F2D9
          C300F3DFCE00E8C7A800D9A27100E0AB7D00E4B38400E6B08100F7E7DA00AB66
          4800AB6B5300E1B79400DC925200E4AB7900E5B38700DB9F6900E0A97700E6B9
          9000EABE9400F4E6DC00A6624400A8674E00BD816200E9B98D00E2975400E29D
          5F00E2A26A00E4AA7700E6B58500F8EADC00CDA28B0095583C00AA674A00CF9B
          7C00EEC39E00E5A56900E6A26600E6A96F00E8B58700F8E8D900E9D2C4006451
          9A00283FD400A8634500C28B6B00EACFB900F8E6D600FAECE100F4E8DF00D0A7
          900059408C001F33D800B9C1F7003C53E400995B3E00A5604100AB644400A661
          420093583C000D11B0001623CB006976E500DCE0FB006F81ED00253ED7000C12
          BA003144DB00BBC3F7002943E6000C12BC00243BC8000202A3000C12BD00131F
          B100000000000000000000000000F80FE50000000000680000000F0200004C7F
          4500000000000000000000000000000000000000000000000000000000000800
          01000000000054A04300C00CE500000000001C00000031000000F2010000EB08
          0000000000000101000000000000010B000000000000CC0EE500000000000F00
          0000F40EE5000000F4000000000000000000F5FFFF001800000083010000A702
          00009F0100001000010000000000000000000000000000000000000000000000
          000060C044000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0F0001000000010000000000000040EEE4000000000001000000407740000000
          0000000000000000000000000000000000000300000000000000E60323000100
          0000000000000000000000000000010000000000000000000000010000000000
          0000000000000000000000000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000080808080808
          0808080808080808080808080808080808080808088788890808080808080808
          0808080808857C73860808080808080808080808817C82838408080808767778
          78797A7B7C7D7E7F800808086B6C6D6E6F707172737475080808086061626364
          65666768696A0808080855565758595A5B475C5D5E5F080808084A4B4C4D4E4F
          504651525354080808083E3F4041424344454647484908080808333435203637
          38393A3B3C3D080808082728292A2B2C2D2E2F303132080808081B1C1D1E1F20
          21222324252608080808081112131415161718191A08080808080808090A0B0C
          0D0E0F1008080808080808080802030405060708080808080808}
        TabOrder = 4
        OnClick = btnPesquisarClick
      end
      object gbRealizar: TGroupBox
        AlignWithMargins = True
        Left = 1
        Top = 4
        Width = 137
        Height = 47
        Margins.Left = 0
        Align = alLeft
        Caption = 'A Realizar '
        TabOrder = 0
        object lbRealizar: TLabel
          AlignWithMargins = True
          Left = 5
          Top = 23
          Width = 127
          Height = 19
          Margins.Top = 8
          Align = alClient
          Alignment = taCenter
          Caption = 'Consulta por CEP'
          ExplicitWidth = 83
          ExplicitHeight = 13
        end
      end
    end
    object grdRegistros: TDBGrid
      Left = 1
      Top = 56
      Width = 974
      Height = 450
      Align = alClient
      DataSource = dsPadrao
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = grdRegistrosDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'CEP'
          Width = 90
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LOGRADOURO'
          Width = 330
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BAIRRO'
          Width = 165
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LOCALIDADE'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UF'
          Width = 53
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'COMPLEMENTO'
          Width = 184
          Visible = True
        end>
    end
  end
  inherited ApplicationEvents: TApplicationEvents
    Left = 66
    Top = 184
  end
  object ConsultaCEP: TConsultaCEP
    OnBeforeConsulta = ConsultaCEPBeforeConsulta
    OnAfterConsulta = ConsultaCEPAfterConsulta
    TipoRetorno = trJSON
    TipoConsulta = tpCEP
    Left = 66
    Top = 239
  end
  object dsPadrao: TDataSource
    Left = 66
    Top = 128
  end
end
