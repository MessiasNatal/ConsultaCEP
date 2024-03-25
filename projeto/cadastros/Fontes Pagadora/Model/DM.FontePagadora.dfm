inherited DMFontePagadora: TDMFontePagadora
  Height = 125
  Width = 212
  inherited AppEvents: TApplicationEvents
    Top = 16
  end
  object qyFontePagadora: TFDQuery
    SQL.Strings = (
      'select'
      '  geral_fonte_pagadora.id_fonte_pagadora,'
      '  geral_fonte_pagadora.nome,'
      '  geral_fonte_pagadora.data_cadastro,'
      '  geral_fonte_pagadora.cep,'
      '  geral_fonte_pagadora.logradouro,'
      '  geral_fonte_pagadora.complemento,'
      '  geral_fonte_pagadora.bairro,'
      '  geral_fonte_pagadora.localidade,'
      '  geral_fonte_pagadora.uf,'
      '  geral_fonte_pagadora.tipo,'
      '  geral_fonte_pagadora.numero,'
      '  geral_fonte_pagadora.documento,'
      '  geral_fonte_pagadora.id_usuario_insercao,'
      '  geral_fonte_pagadora.data_insercao,'
      '  geral_fonte_pagadora.id_usuario_edicao,'
      '  geral_fonte_pagadora.data_edicao'
      'from'
      '  geral_fonte_pagadora'
      'where'
      '  geral_fonte_pagadora.nome like :nome')
    Left = 112
    Top = 16
    ParamData = <
      item
        Name = 'NOME'
        DataType = ftString
        ParamType = ptInput
        Size = 255
      end>
    object qyFontePagadoraID_FONTE_PAGADORA: TIntegerField
      FieldName = 'ID_FONTE_PAGADORA'
      Origin = 'ID_FONTE_PAGADORA'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qyFontePagadoraNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Required = True
      Size = 255
    end
    object qyFontePagadoraDATA_CADASTRO: TDateField
      FieldName = 'DATA_CADASTRO'
      Origin = 'DATA_CADASTRO'
      Required = True
    end
    object qyFontePagadoraCEP: TStringField
      FieldName = 'CEP'
      Origin = 'CEP'
      Required = True
      Size = 10
    end
    object qyFontePagadoraLOGRADOURO: TStringField
      FieldName = 'LOGRADOURO'
      Origin = 'LOGRADOURO'
      Required = True
      Size = 255
    end
    object qyFontePagadoraCOMPLEMENTO: TStringField
      FieldName = 'COMPLEMENTO'
      Origin = 'COMPLEMENTO'
      Size = 255
    end
    object qyFontePagadoraBAIRRO: TStringField
      FieldName = 'BAIRRO'
      Origin = 'BAIRRO'
      Required = True
      Size = 255
    end
    object qyFontePagadoraLOCALIDADE: TStringField
      FieldName = 'LOCALIDADE'
      Origin = 'LOCALIDADE'
      Required = True
      Size = 255
    end
    object qyFontePagadoraUF: TStringField
      FieldName = 'UF'
      Origin = 'UF'
      Required = True
      Size = 2
    end
    object qyFontePagadoraTIPO: TStringField
      FieldName = 'TIPO'
      Origin = 'TIPO'
      Required = True
      FixedChar = True
      Size = 1
    end
    object qyFontePagadoraNUMERO: TStringField
      FieldName = 'NUMERO'
      Origin = 'NUMERO'
      Required = True
      Size = 10
    end
    object qyFontePagadoraDOCUMENTO: TStringField
      FieldName = 'DOCUMENTO'
      Origin = 'DOCUMENTO'
      Required = True
    end
    object qyFontePagadoraID_USUARIO_INSERCAO: TIntegerField
      FieldName = 'ID_USUARIO_INSERCAO'
      Origin = 'ID_USUARIO_INSERCAO'
    end
    object qyFontePagadoraDATA_INSERCAO: TSQLTimeStampField
      FieldName = 'DATA_INSERCAO'
      Origin = 'DATA_INSERCAO'
    end
    object qyFontePagadoraID_USUARIO_EDICAO: TIntegerField
      FieldName = 'ID_USUARIO_EDICAO'
      Origin = 'ID_USUARIO_EDICAO'
    end
    object qyFontePagadoraDATA_EDICAO: TSQLTimeStampField
      FieldName = 'DATA_EDICAO'
      Origin = 'DATA_EDICAO'
    end
  end
end
