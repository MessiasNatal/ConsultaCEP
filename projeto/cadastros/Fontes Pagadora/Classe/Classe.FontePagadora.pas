unit Classe.FontePagadora;

interface

uses
  Classe.Padrao, System.Classes, Vcl.ComCtrls, System.SysUtils, Data.DB, Vcl.Dialogs;

type
  TFontePagadora = class(TClassePadrao)
  public
    constructor Create(pExterna: Boolean = False; pAOwner: TComponent = nil); override;
    procedure Inserir; override;
    procedure Pesquisar(pNome: string);
    procedure Gravar(AplicarApplyUpdates: Boolean); override;
    function ValidarExistenciaCPF(pDocumento: string): Boolean;
    procedure DefinicaoTipo(Sender: TField);
  end;

implementation

{ TFontePagadora }

uses DM.FontePagadora, Constantes, Classe.Helpers.Componentes, Classe.Query, Classe.Utils;

constructor TFontePagadora.Create(pExterna: Boolean = False; pAOwner: TComponent = nil);
begin
  FTabela := 'geral_fonte_pagadora';
  FCampoAutoInc := 'id_fonte_pagadora';
  FModulo := 'Cadastro de Fonte Pagadora';

  Model := TDMFontePagadora.Create(Self);
  dSetPadrao := TDMFontePagadora(Model).qyFontePagadora; inherited;

  dSetPadrao.FieldByName('tipo').OnChange := DefinicaoTipo;
end;

procedure TFontePagadora.DefinicaoTipo(Sender: TField);
begin
  if dSetPadrao.State in [dsInsert,dsEdit] then
  begin
    if dSetPadrao.FieldByName('tipo').AsString = 'F' then
      dSetPadrao.FieldByName('documento').EditMask := '000\.000\.000\-00;1;'
    else if dSetPadrao.FieldByName('tipo').AsString = 'J' then
      dSetPadrao.FieldByName('documento').EditMask := '00\.000\.000/0000-00;1;';
  end
  else
    dSetPadrao.FieldByName('documento').EditMask := '';
end;

procedure TFontePagadora.Gravar(AplicarApplyUpdates: Boolean);
begin
  Validacao.Validar((dSetPadrao.FieldByName('documento').AsString <> '') and (dSetPadrao.FieldByName('tipo').AsString = 'F') and (not TUtils.ValidaCPF(dSetPadrao.FieldByName('documento').AsString)),'Documento Incorreto');
  Validacao.Validar((dSetPadrao.FieldByName('documento').AsString <> '') and (dSetPadrao.FieldByName('tipo').AsString = 'J') and (not TUtils.ValidaCNPJ(dSetPadrao.FieldByName('documento').AsString)),'Documento Incorreto');
  Validacao.Validar((dSetPadrao.State = dsInsert) and (not ValidarExistenciaCPF(dSetPadrao.FieldByName('documento').AsString)),'Documento Já Existe.');
  inherited;
end;

procedure TFontePagadora.Inserir;
begin
  inherited;
  dSetPadrao.FieldByName('data_cadastro').AsDateTime := Date;
end;

procedure TFontePagadora.Pesquisar(pNome: string);
begin
  dSetPadrao.Query.ParamByName('nome').AsString := '%' + pNome + '%';
  Filtrar;
end;

function TFontePagadora.ValidarExistenciaCPF(pDocumento: string): Boolean;
const
  sql = 'select '+
        '  * '+
        'from '+
        '  geral_fonte_pagadora '+
        'where '+
        '  geral_fonte_pagadora.documento = :documento';
begin
  with TQUERY.Create(sql) do
    try
      qy.ParamByName('documento').AsString := pDocumento;
      qy.Open;
      Result := qy.IsEmpty;
    finally
      Free;
    end;
end;

initialization
  RegisterClasses([TFontePagadora]);

end.
