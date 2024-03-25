unit View.Edicao.Padrao;

interface

uses
  Data.DB, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ComCtrls, Vcl.DBCtrls, Vcl.DBGrids, View.Basico.Padrao, System.ImageList,
  Vcl.ImgList, Classe.Helpers.Componentes, Classe.Padrao;

type
  TViewEdicaoPadrao = class(TViewBasicoPadrao)
    pnlPrincipal: TPanel;
    pnlOperacoes: TPanel;
    pgcPrincipal: TPageControl;
    TabSheet1: TTabSheet;
    btnGravar: TBitBtn;
    btnCancelar: TBitBtn;
    dsPadrao: TDataSource;
    ImageListTab: TImageList;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnGravarClick(Sender: TObject);
  private
    procedure Cancelar(FecharView: Boolean = True);
  public
    ObjPadrao: TClassePadrao;
  end;

implementation

{$R *.dfm}

procedure TViewEdicaoPadrao.btnCancelarClick(Sender: TObject);
begin
  if (ObjPadrao = nil) or (ObjPadrao.dSetPadrao = nil) then
  begin
    if dsPadrao.DataSet <> nil then
      if dsPadrao.DataSet.State = dsInsert then
      begin
        dsPadrao.DataSet.Query.Cancel;
        dsPadrao.DataSet.Query.CancelUpdates;
      end;
    Close;
    Exit;
  end;
  Cancelar;
  Close;
end;

procedure TViewEdicaoPadrao.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if (ObjPadrao = nil) or (ObjPadrao.dSetPadrao = nil) then
  begin
    if dsPadrao.DataSet <> nil then
      begin
        dsPadrao.DataSet.Query.Cancel;
        dsPadrao.DataSet.Query.CancelUpdates;
      end;
    Exit;
  end;
  if ObjPadrao <> nil then
    if ObjPadrao.dSetPadrao.State = dsInsert then
      Cancelar(False);
end;

procedure TViewEdicaoPadrao.btnGravarClick(Sender: TObject);
begin
  inherited;
  if (ObjPadrao = nil) or (ObjPadrao.dSetPadrao = nil) then
    Exit;
  ObjPadrao.Gravar;
  Close;
end;

procedure TViewEdicaoPadrao.Cancelar(FecharView: Boolean);
begin
  if (ObjPadrao = nil) or (ObjPadrao.dSetPadrao = nil) then
  begin
    if dsPadrao.DataSet.State = dsInsert then
    begin
      dsPadrao.DataSet.Query.Cancel;
      dsPadrao.DataSet.Query.CancelUpdates;
    end;
    Exit;
  end;
  ObjPadrao.Cancelar;
  if FecharView then
    Close;
end;

procedure TViewEdicaoPadrao.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  inherited;
  if Key = VK_ESCAPE then
   btnCancelar.Click
  else
  if Key = VK_F10 then
    if (btnGravar.Enabled) and (btnGravar.Visible) then
    begin
      btnGravar.SetFocus;
      btnGravar.Click;
    end;
end;

procedure TViewEdicaoPadrao.FormShow(Sender: TObject);
const
  DeixarMaiusculo = 0;
var
  i: Integer;
begin
  inherited;
  try
    if (ObjPadrao <> nil) and (ObjPadrao.dSetPadrao <> nil) then
      dsPadrao.DataSet := ObjPadrao.dSetPadrao;
    pgcPrincipal.ActivePageIndex := 0;
    for i := 0 to Pred(ComponentCount) do
    begin
      if (Self.Components[i] is TDBEdit) and (TDBEdit(Self.Components[i]).Tag = DeixarMaiusculo) then
      begin
        TDBEdit(Self.Components[i]).CharCase := ecUpperCase;
        if (TDBEdit(Self.Components[i]).Enabled) and (TDBEdit(Self.Components[i]).DataSource <> nil) then
          TDBEdit(Self.Components[i]).Enabled := not TDBEdit(Self.Components[i]).DataSource.DataSet.FieldByName(TDBEdit(Self.Components[i]).DataField).ReadOnly;
      end
      else
      if (Self.Components[i] is TEdit) and (TEdit(Self.Components[i]).Tag = DeixarMaiusculo) then
        TEdit(Self.Components[i]).CharCase := ecUpperCase
      else
      if (Self.Components[i] is TDateTimePicker) and (dsPadrao.DataSet <> nil) and (dsPadrao.DataSet.State = dsInsert) then
        TDateTimePicker(Self.Components[i]).Date := Date;
    end;
  except
    on e: Exception do
      raise Exception.Create('Ops! Erro ao Carregar Evento OnShow, Contate o suporte para Análise.'+#13#10+'Erro: '+e.Message);
  end;
end;

end.
