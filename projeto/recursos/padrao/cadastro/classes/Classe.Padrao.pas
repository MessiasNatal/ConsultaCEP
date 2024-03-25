unit Classe.Padrao;

interface

uses
  System.SysUtils, Vcl.Forms, Vcl.ComCtrls, System.Classes, Winapi.Windows, Data.DB,
  Vcl.ExtCtrls, Classe.Padrao.Basico, Vcl.Buttons, Vcl.Controls;

type
  TClassePadrao = class;

  TValidacao = class
  strict private
    FObjPadrao: TClassePadrao;
  public
    constructor Create(ObjPadrao: TClassePadrao);
    destructor Destroy; override;

    function ValidaCampos: Boolean; virtual;
    function Perguntar(Mensagem: string; pAbortar: Boolean = True): Boolean;
    function PerguntarRetorno(Mensagem: string): Boolean;
    function Validar(Validacao: Boolean; Mensagem: string; pAbortar: Boolean = True): Boolean;
  end;

  TView = class
  strict private
    FObjPadrao: TClassePadrao;
  public
    constructor Create(ObjPadrao: TClassePadrao);
    destructor Destroy; override;

    class function AbreFormCadastros(pComponent: TComponent; pView: string = ''; pUsarTab: Boolean = True; pTabImageIndex: Integer = 0): TClassePadrao;
    class procedure AbreFormCadastrosReinicioSessao(pComponent: TComponent; pView: string = ''; pUsarTab: Boolean = True);

    function AbreFormCadastrosInsertEdit: Boolean;
    function AbreForm(View: string; ShowModal: Boolean = True; Owner: TComponent = nil): TCustomForm;
  end;

  TPadraoClass = class of TClassePadrao;

  TClassePadrao = class(TClassePadraoBasico)
  strict private
    FValidacao: TValidacao;
    FView: TView;
  protected
    FTabela: string;
    FCampoAutoInc: string;
    FModulo: string;
  public
    class function New(ClassName: string; pExterna: Boolean = False; pAOwner: TComponent = nil): TClassePadrao;

    constructor Create(pExterna: Boolean = False; pAOwner: TComponent = nil); virtual;
    destructor Destroy; override;

    procedure Close; virtual;
    procedure Inserir; virtual;
    procedure Editar; virtual;
    procedure Gravar(AplicarApplyUpdates: Boolean = True); virtual;
    procedure Excluir(Perguntar: Boolean = True); virtual;
    procedure Cancelar; virtual;
    procedure Atualizar(IdLocate: Integer = 0); virtual;
    procedure Filtrar;

    property Validacao: TValidacao read FValidacao;
    property View: TView read FView;
    property Tabela: string read FTabela;
    property CampoAutoInc: string read FCampoAutoInc;
    property Modulo: string read FModulo;
  end;

implementation

{ TClassePadrao }

uses
  Classe.Key, View.Edicao.Padrao, Constantes, Classe.Ini, Classe.Helpers.Componentes, View.Cadastro.Padrao, View.Basico.Padrao, Classe.Utils;

class function TClassePadrao.New(ClassName: string; pExterna: Boolean = False; pAOwner: TComponent = nil): TClassePadrao;
var
  Obj: TPadraoClass;
begin
  Obj := TPadraoClass(GetClass(ClassName));
  if Obj = nil then
    raise Exception.Create('Objeto não existe' + ' - ' + ClassName)
  else
  begin
    Result := Obj.Create as TClassePadrao;

    if pAOwner <> nil then
      pAOwner.InsertComponent(Result);
  end;
end;

constructor TClassePadrao.Create(pExterna: Boolean = False; pAOwner: TComponent = nil);
begin
  Self.Name := 'obj' + Copy(Self.ClassName,2,Length(Self.ClassName)); inherited;
  FValidacao := TValidacao.Create(Self);
  FView := TView.Create(Self);
  if dSetPadrao <> nil then
    Self.dSetPadrao.Name := 'qy'+ Copy(Self.ClassName,2,Length(Self.ClassName));
  if (pAOwner<>nil) and (not(pAOwner is TClassePadrao)) then
    pAOwner.InsertComponent(Self);
  Filtrar;
end;

destructor TClassePadrao.Destroy;
begin
  FreeAndNil(FValidacao);
  FreeAndNil(FView);
  inherited;
end;

procedure TClassePadrao.Inserir;

  procedure CamposValorPadrao;
  begin
    if dSetPadrao.FindField(FIELDNAME_IdSetor) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_IdSetor,Sessao.IdSetor);

    if dSetPadrao.FindField(FIELDNAME_IdEmpresa) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_IdEmpresa,Sessao.IdEmpresa);

    if dSetPadrao.FindField(FIELDNAME_DATALANCAMENTO) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_DATALANCAMENTO,Date);

    if dSetPadrao.FindField(FIELDNAME_DATA_MOVIMENTACAO) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_DATA_MOVIMENTACAO,Date);

    if dSetPadrao.FindField(FIELDNAME_DATA_INSERCAO) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_DATA_INSERCAO,DateTimeToStr(Now));

    if dSetPadrao.FindField(FIELDNAME_DATA_EMISSAO) <> nil then
      dSetPadrao.SetValueReadOnly(FIELDNAME_DATA_EMISSAO,Date);

    if dSetPadrao.FindField(FIELDNAME_DATA_EMISSAO) <> nil then
      dSetPadrao.FieldByName(FIELDNAME_DATA_EMISSAO).ReadOnly := True;

    if dSetPadrao.FindField(FIELDNAME_DATALANCAMENTO) <> nil then
      dSetPadrao.FieldByName(FIELDNAME_DATALANCAMENTO).ReadOnly := True;
  end;

  procedure AutoInc;
  begin
    dSetPadrao.FieldByName(FCampoAutoInc).AsInteger := TKey.getKey(FTabela,FCampoAutoInc);
  end;

begin
  if not (dSetPadrao.State = dsInsert) then
  begin
    dSetPadrao.Append;
    AutoInc;
    CamposValorPadrao;
  end;
end;

procedure TClassePadrao.Editar;

  procedure HabilitarFields;
  var
    Fields: array of string;
    i: Integer;
  begin
    SetLength(Fields,dSetPadrao.FieldCount);
    for i := 0 to Pred(dSetPadrao.FieldCount) do
      Fields[i] := dSetPadrao.Fields[i].FieldName;
  end;

  procedure CampoPadrao;
  begin
    if dSetPadrao.FindField(FIELDNAME_DATALANCAMENTO) <> nil then
      dSetPadrao.FieldByName(FIELDNAME_DATALANCAMENTO).ReadOnly := True;

    if dSetPadrao.FindField(FIELDNAME_DATA_EMISSAO) <> nil then
      dSetPadrao.FieldByName(FIELDNAME_DATA_EMISSAO).ReadOnly := True;

    if (dSetPadrao.FindField(FIELDNAME_DATA_EDICAO) <> nil) and (not dSetPadrao.FindField(FIELDNAME_DATA_EDICAO).ReadOnly) then
      dSetPadrao.FindField(FIELDNAME_DATA_EDICAO).Value := DateTimeToStr(Now);
  end;

begin
  if dSetPadrao.IsEmpty then
  begin
    TUtils.Mensagem('Nenhum Registro Encontrado.');
    Exit;
  end;
  HabilitarFields;
  dSetPadrao.Edit;
  CampoPadrao;
end;

procedure TClassePadrao.Excluir(Perguntar: Boolean = True);
begin
  if dSetPadrao.IsEmpty then
  begin
    TUtils.Mensagem('Nenhum Registro Encontrado.');
    Exit;
  end;
  if Perguntar then
    Validacao.Perguntar('Confirma Exclusão ?');
  dSetPadrao.Delete;
  dSetPadrao.Query.ApplyUpdates(0);
  dSetPadrao.Query.CommitUpdates;
end;

procedure TClassePadrao.Atualizar(IdLocate: Integer = 0);
var
  i, Id: Integer;
begin
  if dSetPadrao = nil then
    Exit;
  try
    id := TUtils.ifThen(IdLocate = 0,TUtils.ifThen(dSetPadrao.FieldByName(FCampoAutoInc).AsString = '','0',dSetPadrao.FieldByName(FCampoAutoInc).AsString),IdLocate.ToString).ToInteger;
    dSetPadrao.Query.CommitUpdates;
    dSetPadrao.Refresh;
  finally
    dSetPadrao.Locate(FCampoAutoInc,Id,[]);
  end;
end;

procedure TClassePadrao.Gravar(AplicarApplyUpdates: Boolean = True);
begin
  Validacao.ValidaCampos;

  dSetPadrao.Post;
  dSetPadrao.Query.ApplyUpdates(0);
  dSetPadrao.Query.CommitUpdates;
  Atualizar;
end;

procedure TClassePadrao.Close;
begin
  if dSetPadrao = nil then
    Exit;
  if dSetPadrao.Active then
    Close;
end;

procedure TClassePadrao.Cancelar;
begin
  if dSetPadrao = nil then
    Exit;
  dSetPadrao.Cancel;
end;

procedure TClassePadrao.Filtrar;
var
  Id: Integer;
begin
  if (dSetPadrao = nil) or (Pos('%',dSetPadrao.Query.SQL.Text) > 0)  then
    Exit;
  Id := 0;
  if not dSetPadrao.IsEmpty then
    Id := dSetPadrao.FieldByName(FCampoAutoInc).AsInteger;
  dSetPadrao.Close;
  TUtils.AbrirDataSets([dSetPadrao]);
  dSetPadrao.Locate(FCampoAutoInc,Id,[]);
end;

{ TValidacao }

constructor TValidacao.Create(ObjPadrao: TClassePadrao);
begin
  FObjPadrao := ObjPadrao;
end;

destructor TValidacao.Destroy;
begin
  inherited;
end;

function TValidacao.Validar(Validacao: Boolean; Mensagem: string; pAbortar: Boolean): Boolean;
begin
  Result := Validacao;
  if Result then
  begin
    TUtils.Mensagem(Mensagem);
    if pAbortar then
      Abort;
  end;
end;

function TValidacao.Perguntar(Mensagem: string; pAbortar: Boolean = True): Boolean;
begin
  Result := MessageBox(0,PWideChar(Mensagem),'Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO) = ID_YES;
  if (not Result) and (pAbortar) then
    Abort;
end;

function TValidacao.PerguntarRetorno(Mensagem: string): Boolean;
begin
  Result := True;
  if MessageBox(0,PWideChar(Mensagem),'Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_NO then
    Result := False;
end;

function TValidacao.ValidaCampos: Boolean;
begin
  Result := TUtils.ValidaCampos(FObjPadrao.dSetPadrao);
  if not Result then
    Abort;
end;

{ TView }

function TView.AbreForm(View: string; ShowModal: Boolean = True; Owner: TComponent = nil): TCustomForm;
var
  Obj : TFormClass;
begin
  Obj := TFormClass(GetClass(View));
  try
    Result := (Obj.Create(Owner) as TCustomForm);
  except
    on e: Exception do
      TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+Format('%s não Registrado. %s',[Result.Name,e.Message]));
  end;
  try
    if ShowModal then
      Result.ShowModal;
  except
    on e: Exception do
      TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+Format('%s',[e.Message]));
  end;
end;

class procedure TView.AbreFormCadastrosReinicioSessao(pComponent: TComponent; pView: string = ''; pUsarTab: Boolean = True);
var
  ObjVerify: TFormClass;
  NewViewVerify: TCustomForm;
begin
  ObjVerify := nil;
  NewViewVerify := nil;
  ObjVerify := TFormClass(GetClass(pView));
  NewViewVerify := (ObjVerify.Create(pComponent) as TCustomForm);
  if (NewViewVerify is TViewCadastroPadrao) or (NewViewVerify.Tag = 1) then
  begin
    ObjVerify := nil;
    NewViewVerify.Free;
    AbreFormCadastros(pComponent,pView);
  end
  else
  begin
    ObjVerify := nil;
    NewViewVerify.Free;
  end;
end;

class function TView.AbreFormCadastros(pComponent: TComponent; pView: string; pUsarTab: Boolean; pTabImageIndex: Integer): TClassePadrao;
var
  Obj: TFormClass;
  NewView: TCustomForm;
  i: Integer;
  Existe: Boolean;
begin
  Existe := False;

  for i := 0 to Pred(TPageControl(pComponent).ControlCount) do
    if TPageControl(pComponent).Controls[i] is TTabSheet then
      if LowerCase(TTabSheet(TPageControl(pComponent).Controls[i]).Name) = LowerCase(pView) then
      begin
        TPageControl(pComponent).ActivePage := TPageControl(pComponent).Controls[i] as TTabSheet;
        Existe := True;
        Break;
      end;

  if Existe then
    Exit;

  Obj := TFormClass(GetClass(pView));

  if Obj = nil then
  begin
    raise Exception.Create('Opção disponível em breve');
  end;

  try
    NewView := (Obj.Create(pComponent) as TCustomForm);
  except
    on e: Exception do
      TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+Format('%s não Registrado. %s',[NewView.Name,e.Message]));
  end;

  try
    if not pUsarTab then
      NewView.Show
    else
    begin
      TViewBasicoPadrao(NewView).TabPadrao.ImageIndex := pTabImageIndex;
      TViewBasicoPadrao(NewView).TabPadrao.PageControl := TPageControl(pComponent);
      try
        TPanel(TViewBasicoPadrao(NewView).FindComponent('PnlPrincipal')).Parent := TViewBasicoPadrao(NewView).TabPadrao;
      except
        TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+'PnlPrincipal não encontrado');
      end;
      TPageControl(pComponent).ActivePage := TViewBasicoPadrao(NewView).TabPadrao;
    end;

    TPageControl(pComponent).Align := alClient;
    Result := TViewBasicoPadrao(NewView).ObjPadrao;

  except
    on e: Exception do
      TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+Format('%s',[e.Message]));
  end;
end;

function TView.AbreFormCadastrosInsertEdit: Boolean;
var
  Obj: TFormClass;
  NewView: TCustomForm;
  ViewName: string;
begin
  if ((FObjPadrao.dSetPadrao.IsEmpty) or (FObjPadrao.dSetPadrao.State = dsBrowse)) then
    Abort;

  ViewName := 'TView'+Self.FObjPadrao.ToString.Substring(1,Length(Self.FObjPadrao.ToString))+'InsertEdit';

  Obj := TFormClass(GetClass(ViewName));
  try
    NewView := Obj.Create(FObjPadrao) as TCustomForm;
  except
    on e: Exception do
      TUtils.MsgInfo('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.'+sLineBreak+Format('View: "%s" não Registrado. %s %s',[ViewName,sLineBreak,e.Message]));
  end;

  try
    TViewEdicaoPadrao(NewView).ObjPadrao := FObjPadrao;
    TViewEdicaoPadrao(NewView).dsPadrao.DataSet := FObjPadrao.dSetPadrao;
    NewView.ShowModal;
    Result := (NewView.ModalResult = mrOk);
  except
    on e: Exception do
      raise Exception.Create('Ops! Houve um erro ao carregar tela de registro, contate o suporte para análise.' + sLineBreak + e.Message);
  end;
end;

constructor TView.Create(ObjPadrao: TClassePadrao);
begin
  FObjPadrao := ObjPadrao;
end;

destructor TView.Destroy;
var
  i: Integer;
begin
  for i := 0 to Pred(Self.FObjPadrao.ComponentCount) do
    if Self.FObjPadrao.Components[i] is TForm then
    begin
      TForm(Self.FObjPadrao.Components[i]).Hide;
      TForm(Self.FObjPadrao.Components[i]).Close;
      Self.FObjPadrao.RemoveComponent(Self.FObjPadrao.Components[i]);
    end;
  inherited;
end;

end.
