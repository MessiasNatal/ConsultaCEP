unit View.Cadastro.Padrao;

interface

uses
  Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Actions, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons, Vcl.ActnList, Vcl.Menus, Vcl.ComCtrls, Vcl.DBCtrls, View.Basico.Padrao,
  Classe.Padrao, System.ImageList, Vcl.ImgList;

type
  TViewCadastroPadrao = class(TViewBasicoPadrao)
    pnlPrincipal: TPanel;
    pnlOperacoes: TPanel;
    btnInserir: TBitBtn;
    btnExcluir: TBitBtn;
    btnEditar: TBitBtn;
    btnFechar: TBitBtn;
    ActionList: TActionList;
    actInserir: TAction;
    actExcluir: TAction;
    actEditar: TAction;
    actPesquisar: TAction;
    actFechar: TAction;
    dsPadrao: TDataSource;
    pnlInfo: TPanel;
    lblQtdRegistro: TLabel;
    ImgList: TImageList;
    lbOrdenacao: TLabel;
    pnlFiltro: TPanel;
    btnPesquisar: TBitBtn;
    edtPesquisa: TEdit;
    lblPesquisa: TLabel;
    grdRegistros: TDBGrid;
    procedure FormCreate(Sender: TObject);
    procedure actFecharExecute(Sender: TObject);
    procedure actInserirExecute(Sender: TObject);
    procedure actEditarExecute(Sender: TObject);
    procedure grdRegistrosDblClick(Sender: TObject);
    procedure actExcluirExecute(Sender: TObject);
  end;

implementation

uses
  Constantes, Classe.Helpers.Componentes;

{$R *.dfm}

procedure TViewCadastroPadrao.actEditarExecute(Sender: TObject);
begin
  inherited;
  ObjPadrao.Editar;
  ObjPadrao.View.AbreFormCadastrosInsertEdit;
end;

procedure TViewCadastroPadrao.actExcluirExecute(Sender: TObject);
begin
  inherited;
  ObjPadrao.Excluir;
end;

procedure TViewCadastroPadrao.actFecharExecute(Sender: TObject);
begin
  Close;
end;

procedure TViewCadastroPadrao.actInserirExecute(Sender: TObject);
begin
  inherited;
  ObjPadrao.Inserir;
  ObjPadrao.View.AbreFormCadastrosInsertEdit;
end;

procedure TViewCadastroPadrao.FormCreate(Sender: TObject);
var
  Validacao: Boolean;

  procedure CriarObjetoPadrao;
  begin
    if ObjPadrao <> nil then
      Exit;
    ObjPadrao := TClassePadrao.New('T'+Copy(Self.Name,5,Length(Self.Name)),False,Self);
    Validacao := ObjPadrao <> nil;
  end;

var
  i: Integer;
begin
  CriarObjetoPadrao;

  if Validacao then
  begin
    inherited;
    dsPadrao.DataSet := ObjPadrao.dSetPadrao;
  end;

  for i := 0 to Pred(Self.ComponentCount) do
  begin
    if Self.Components[i] is TBitBtn then
    begin
      TBitBtn(Self.Components[i]).AlignWithMargins := True;

      TBitBtn(Self.Components[i]).Margins.Bottom := 1;
      TBitBtn(Self.Components[i]).Margins.Left := 1;
      TBitBtn(Self.Components[i]).Margins.Right := 1;
      TBitBtn(Self.Components[i]).Margins.Top := 0;

      if TBitBtn(Self.Components[i]).Left < 5 then
        TBitBtn(Self.Components[i]).Margins.Left := 0;
    end;
  end;
end;

procedure TViewCadastroPadrao.grdRegistrosDblClick(Sender: TObject);
begin
  inherited;
  if (not TDBGrid(Sender).DataSource.DataSet.IsEmpty) and (TDBGrid(Sender).DataSource.DataSet.FindField('dsc_selecionado')<> nil) and (TDBGrid(Sender).DataSource.DataSet.FieldByName('dsc_selecionado').AsString = 'S') then
  begin
    TDBGrid(Sender).DataSource.DataSet.Edit;
    TDBGrid(Sender).DataSource.DataSet.FieldByName('dsc_selecionado').AsString := 'N';
    TDBGrid(Sender).DataSource.DataSet.Post;
  end
  else
  if (not TDBGrid(Sender).DataSource.DataSet.IsEmpty) and (TDBGrid(Sender).DataSource.DataSet.FindField('dsc_selecionado')<> nil) then
  begin
    TDBGrid(Sender).DataSource.DataSet.Edit;
    TDBGrid(Sender).DataSource.DataSet.FieldByName('dsc_selecionado').AsString := 'S';
    TDBGrid(Sender).DataSource.DataSet.Post;
  end;
end;

end.
