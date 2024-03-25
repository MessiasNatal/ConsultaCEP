unit View.Basico.Padrao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.DBGrids, System.DateUtils, Vcl.AppEvnts, Classe.Padrao, Data.DB,
  Vcl.Menus, System.ImageList, Vcl.ImgList, System.UITypes;

type
  TEventSourceOnDataChangePadrao = procedure (Sender: TObject) of object;

  TViewBasicoPadrao = class(TForm)
    ApplicationEvents: TApplicationEvents;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ApplicationEventsException(Sender: TObject; E: Exception);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure loadConfigTabPagina;
    procedure OnDBGridTitleClickCustom(Column: TColumn);
    procedure OnDataSourceDataChangeCustom(Sender: TObject; Field: TField);
  private
    FSourceOnDataChangePadrao: TEventSourceOnDataChangePadrao;
    FAddLista: Boolean;
  protected
    GridColunaSelecionada: string;
    function Exibir(pDataSet: TDataSet; pCampos: string): Boolean; virtual; abstract;
  public
    TabPadrao: TTabSheet;
    ObjPadrao: TClassePadrao;
    procedure Perguntar(Mensagem: string);
    procedure Desabilitar(pExceto: array of TControl); overload;
    procedure Inatividade(pCampos: array of TControl; Ativar: Boolean);
    procedure Invisibilitar(pCampos: array of TControl; Ativar: Boolean);
    procedure Habilitar(pExceto: TControl);
    procedure LimparCampos(Componente: array of TDBEdit);
    procedure OnClickNaoPermitido(Sender: TObject);
    procedure DbClick(Sender: TObject);
    procedure OnClose(Sender: TObject);
    function Validar(Validacao: Boolean; Mensagem: string): Boolean;
    procedure OnChangeDataFiltro(Sender: TObject);

    property SourceOnDataChangePadrao: TEventSourceOnDataChangePadrao read FSourceOnDataChangePadrao write FSourceOnDataChangePadrao;
  end;

implementation

{$R *.dfm}

uses
  Constantes, View.Edicao.Padrao, View.Cadastro.Padrao, Classe.Helpers.Componentes, Datasnap.DBClient, Classe.Helpers.ClassePadrao;

{ TViewBasicoPadrao }

procedure TViewBasicoPadrao.ApplicationEventsException(Sender: TObject; E: Exception);
begin
  if Pos('aborted',E.Message) = 0 then
  begin
    if Pos('Invalid input', E.Message) > 0 then
      MessageDlg('Valor Digitado Inválido.',mtWarning,[mbok],0)
    else
    if Pos('is not a valid time', E.Message) > 0 then
      MessageDlg(Format('%s Inválido..',[TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).DisplayName]),mtWarning,[mbok],0)
    else
    if Pos('foreign key constraint', E.Message) > 0 then
      MessageDlg('Operação Não Permitida.',mtWarning,[mbok],0)
    else
      raise Exception.Create(e.Message);
  end;
  Abort;
end;

procedure TViewBasicoPadrao.OnDataSourceDataChangeCustom(Sender: TObject; Field: TField);
begin
  if (TDataSource(Sender).DataSet <> nil) and (Self.FindComponent('lblQtdRegistro') <> nil) then
    TLabel(Self.FindComponent('lblQtdRegistro')).Caption := TDataSource(Sender).DataSet.RecordCount.ToString + ' - Registro(s)';
  if Assigned(FSourceOnDataChangePadrao) then
    FSourceOnDataChangePadrao(Sender);
end;

procedure TViewBasicoPadrao.OnDBGridTitleClickCustom(Column: TColumn);
var
  i: Integer;
begin
  for i := 0 to Pred(TDBGrid(Column.Grid).Columns.Count) do
    TDBGrid(Column.Grid).Columns[i].Title.Font.Style := [];
  TDBGrid(Column.Grid).Columns[Column.Index].Title.Font.Style := [fsUnderline,fsBold,fsItalic];
  GridColunaSelecionada := Column.FieldName;
end;

procedure TViewBasicoPadrao.DbClick(Sender: TObject);
begin
  if(Sender is TDBEdit) and
    (TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).DataType = ftTime) or
    (TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).DataType = ftDate) or
    (TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).DataType = ftDateTime)
  then
  begin
    TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).EditMask := '';
    TDBEdit(Sender).Clear;
    TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).Clear;
    case TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).DataType of
      ftTime:
        TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).EditMask := '!90:00;1;_';
      ftDate,ftDateTime:
        TDBEdit(Sender).DataSource.DataSet.FieldByName(TDBEdit(Sender).DataField).EditMask := '!99/99/0000;1;_';
    end;
  end;
end;

procedure TViewBasicoPadrao.Desabilitar(pExceto: array of TControl);
var
  i: Integer;
begin
  for i := 0 to Pred(Self.ComponentCount) do
    if(Self.Components[i] is TDBEdit) or
      (Self.Components[i] is TDBMemo) or
      (Self.Components[i] is TDBCheckBox) or
      (Self.Components[i] is TDBRadioGroup) or
      (Self.Components[i] is TDBListBox)
    then
      TControl(Self.Components[i]).Enabled := False
    else
    if Self.Components[i] is TSpeedButton then
      TControl(Self.Components[i]).Enabled := False;
  for i := 0 to High(pExceto) do
    pExceto[i].Enabled := True;
end;

procedure TViewBasicoPadrao.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TViewBasicoPadrao.FormCreate(Sender: TObject);
var
  i: Integer;
  InicioMes, FinalMes, Mes, Ano: Word;
  dbcControl, Campos: string;
begin
  for i := 0 to Pred(ComponentCount) do
  begin
    if Self.Components[i] is TBitBtn then
    begin
      TBitBtn(Self.Components[i]).Tag := -1;
      TBitBtn(Self.Components[i]).Cursor := crHandPoint;
      if (not Assigned(TBitBtn(Self.Components[i]).OnClick)) and (Self.Components[i].Name = 'btnFechar') then
        TBitBtn(Self.Components[i]).OnClick := OnClose;
    end
    else
    if Self.Components[i] is TDateTimePicker then
    begin
      if TDateTimePicker(Self.Components[i]).Name = 'dtDataInicial' then
      begin
        Ano := StrToInt(FormatDateTime('yyyy',Date));
        Mes := StrToInt(FormatDateTime('mm',Date));
        InicioMes := 1;
        TDateTimePicker(Self.Components[i]).Date := EncodeDate(Ano,Mes,InicioMes);

        TDateTimePicker(Self.Components[i]).OnChange := OnChangeDataFiltro;
        TDateTimePicker(Self.Components[i]).OnClick := OnChangeDataFiltro;
      end
      else
      if TDateTimePicker(Self.Components[i]).Name = 'dtDataFinal' then
      begin
        Ano := StrToInt(FormatDateTime('yyyy',Date));
        Mes := StrToInt(FormatDateTime('mm',Date));
        FinalMes := DaysInMonth(Date);
        TDateTimePicker(Self.Components[i]).Date := EncodeDate(Ano,Mes,FinalMes);

        TDateTimePicker(Self.Components[i]).OnChange := OnChangeDataFiltro;
        TDateTimePicker(Self.Components[i]).OnClick := OnChangeDataFiltro;
      end
    end
    else
    if Self.Components[i] is TDBGrid then
    begin
      TDBGrid(Self.Components[i]).Options := [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgTitleClick, dgConfirmDelete];
      TDBGrid(Self.Components[i]).OnTitleClick := OnDBGridTitleClickCustom;
    end
    else
    if (Self.Components[i] is TDataSource) and (TDataSource(Self.Components[i]).Name = 'dsPadrao') then
      TDataSource(Self.Components[i]).OnDataChange := OnDataSourceDataChangeCustom;
    if Self.Components[i] is TEdit then
      TEdit(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBEdit then
    begin
      TEdit(Self.Components[i]).ParentFont := False;
      TEdit(Self.Components[i]).OnDblClick := DbClick;
    end
    else
    if Self.Components[i] is TDateTimePicker then
      TDateTimePicker(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TLabel then
      TLabel(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBGrid then
      TDBGrid(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TMemo then
      TMemo(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBMemo then
      TDBMemo(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBRadioGroup then
      TDBRadioGroup(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TRadioGroup then
      TRadioGroup(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TCheckBox then
      TCheckBox(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBCheckBox then
      TDBCheckBox(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TComboBox then
      TComboBox(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TDBLookupListBox then
      TDBLookupListBox(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TBitBtn then
      TBitBtn(Self.Components[i]).ParentFont := False
    else
    if Self.Components[i] is TSpeedButton then
    begin
      TSpeedButton(Self.Components[i]).ParentFont := False;
      TSpeedButton(Self.Components[i]).Cursor := crHandPoint;
      TSpeedButton(Self.Components[i]).Flat := True;
    end
    else
    if Self.Components[i] is TPanel then
      TPanel(Self.Components[i]).ParentBackground := False;
    if Self.Components[i] is TWinControl then
      TWinControl(Self.Components[i]).ShowHint := True;
  end;
  LoadConfigTabPagina;
  if ObjPadrao <> nil then
    ObjPadrao.Filtrar;
end;

procedure TViewBasicoPadrao.FormShow(Sender: TObject);
var
  i: Integer;
  dbcControl, Campos: string;
begin
  for i := 0 to Pred(Self.ComponentCount) do
  begin
    if Self.Components[i] is TDBMemo then
      TDBMemo(Self.Components[i]).Enabled := not TDBMemo(Self.Components[i]).DataSource.DataSet.FieldByName(TDBMemo(Self.Components[i]).DataField).ReadOnly
    else
    if Self.Components[i] is TDBRadioGroup then
      TDBRadioGroup(Self.Components[i]).Enabled := not TDBRadioGroup(Self.Components[i]).DataSource.DataSet.FieldByName(TDBRadioGroup(Self.Components[i]).DataField).ReadOnly;
  end;
  KeyPreview := True;
  BorderStyle := bsToolWindow;
  BorderIcons := [];
end;

procedure TViewBasicoPadrao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TViewBasicoPadrao.Habilitar(pExceto: TControl);
begin
  pExceto.Enabled := True;
end;

procedure TViewBasicoPadrao.Inatividade(pCampos: array of TControl; Ativar: Boolean);
var
  i: Integer;
begin
  for i := 0 to High(pCampos) do
    pCampos[i].Enabled := Ativar;
end;

procedure TViewBasicoPadrao.Invisibilitar(pCampos: array of TControl; Ativar: Boolean);
var
  i: Integer;
begin
  for i := 0 to High(pCampos) do
    if pCampos[i] is TTabSheet then
      TTabSheet(pCampos[i]).TabVisible := Ativar
    else
      pCampos[i].Visible := Ativar;
end;

procedure TViewBasicoPadrao.LimparCampos(Componente: array of TDBEdit);
var
  i: Integer;
begin
  for i := 0 to High(Componente) do
    Componente[i].Clear;
end;

procedure TViewBasicoPadrao.loadConfigTabPagina;
begin
  TabPadrao := TTabSheet.Create(Self);
  TabPadrao.Name := Self.ClassName;
  TabPadrao.Caption := Self.Caption;
end;


function TViewBasicoPadrao.Validar(Validacao: Boolean; Mensagem: string): Boolean;
begin
  Result := Validacao;
  if Result then
    raise Exception.Create(Mensagem);
end;

procedure TViewBasicoPadrao.OnChangeDataFiltro(Sender: TObject);
begin
  if (Self.FindComponent('dtDataInicial')<>nil) and (Self.FindComponent('dtDataFinal')<>nil) and (Self.FindComponent('btnPesquisar')<>nil) then
    TBitBtn(Self.FindComponent('btnPesquisar')).OnClick(Self.FindComponent('btnPesquisar'));
end;

procedure TViewBasicoPadrao.OnClickNaoPermitido(Sender: TObject);
begin
  raise Exception.Create('Operação Não Permitida.');
end;

procedure TViewBasicoPadrao.OnClose(Sender: TObject);
begin
  Close;
end;

procedure TViewBasicoPadrao.Perguntar(Mensagem: string);
begin
  if MessageBox(0,PWideChar(Mensagem),'Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_NO then
    Abort;
end;
end.
