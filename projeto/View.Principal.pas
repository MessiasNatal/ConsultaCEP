unit View.Principal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Constantes, Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.WinXCtrls, Classe.Ini, Classe.Padrao,
  View.Basico.Padrao, Vcl.DBGrids, System.ImageList, Vcl.ImgList, Vcl.TitleBarCtrls;

type
  TViewPrincipal = class(TForm)
    stbInfo: TStatusBar;
    pnlPrincipal: TPanel;
    tbcMenuLateral: TTabControl;
    pnlMenuLateral: TPanel;
    ScrollBoxMenu: TScrollBox;
    pnlCadastros: TPanel;
    pnlTituloCadastroGeral: TPanel;
    lblTituloCadastroGeral: TLabel;
    pgcView: TPageControl;
    TitleBarCustom: TTitleBarPanel;
    imgLogo: TImage;
    pnlSistema: TPanel;
    pnlFechar: TPanel;
    imgFechar: TImage;
    pnlMinimizar: TPanel;
    imgMinimizar: TImage;
    pnlMaximizar: TPanel;
    imgMaximizar: TImage;
    ImageList: TImageList;
    btnFontePagadora: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgMinimizarClick(Sender: TObject);
    procedure imgMaximizarClick(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
  private
    procedure ShowView(Sender: TObject); overload;
    procedure ShowView(ClassName: string); overload;

    procedure AtalhoInserir;
    procedure AtalhoEditar;
    procedure AtalhoExcluir;
    procedure AtalhoPesquisar(ApenasRefresh: Boolean = False);
    procedure AtalhoFechar;
  end;

const
  EventoChamadaView = 1;
var
  ViewPrincipal: TViewPrincipal;

implementation

{$R *.dfm}

procedure TViewPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if MessageBox(0,'Deseja realmente finalizar o sistema ?','Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_NO then
    Abort;
end;

procedure TViewPrincipal.FormCreate(Sender: TObject);

  procedure Propriedades;
  var
    i: Integer;
  begin
     for i := 0 to Pred(Self.ComponentCount) do
       if (Self.Components[i] is TSpeedButton) and (TSpeedButton(Self.Components[i]).Tag = EventoChamadaView) and (not Assigned(TSpeedButton(Self.Components[i]).OnClick)) then
         TSpeedButton(Self.Components[i]).OnClick := ShowView;

    Caption := App + ' - ' + Versao;
  end;

begin
  Propriedades;
end;

procedure TViewPrincipal.ShowView(Sender: TObject);
begin
  ShowView('TView'+Copy(TComponent(Sender).Name,4,Length(TComponent(Sender).Name)));
end;

procedure TViewPrincipal.ShowView(ClassName: string);
begin
  TView.AbreFormCadastros(pgcView,ClassName);
end;

procedure TViewPrincipal.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    VK_F9: AtalhoInserir;
    VK_F12: AtalhoEditar;
    VK_DELETE: AtalhoExcluir;
    VK_F5: AtalhoPesquisar;
    VK_ESCAPE: AtalhoFechar;
  end;
end;

procedure TViewPrincipal.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TViewPrincipal.imgMaximizarClick(Sender: TObject);
begin
  if WindowState = wsMaximized then
    WindowState := TWindowState.wsNormal
  else
    WindowState := TWindowState.wsMaximized
end;

procedure TViewPrincipal.imgMinimizarClick(Sender: TObject);
begin
  SendMessage(Self.Handle, WM_SYSCOMMAND, SC_MINIMIZE, 0);
end;

procedure TViewPrincipal.AtalhoInserir;
begin
  if(pgcView.ActivePage <> nil) and
    (pgcView.ActivePage.ControlCount > 0) and
    (pgcView.ActivePage.Controls[0] <> nil) and
    (pgcView.ActivePage.Controls[0].Owner <> nil) and
    (pgcView.ActivePage.Controls[0].Owner.FindComponent('btnInserir') <> nil) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnInserir')).Enabled) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnInserir')).Visible)
  then
  begin
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnInserir')).SetFocus;
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnInserir')).Click;
  end;
end;

procedure TViewPrincipal.AtalhoEditar;
begin
  if(pgcView.ActivePage <> nil) and
    (pgcView.ActivePage.ControlCount > 0) and
    (pgcView.ActivePage.Controls[0] <> nil) and
    (pgcView.ActivePage.Controls[0].Owner <> nil) and
    (pgcView.ActivePage.Controls[0].Owner.FindComponent('btnEditar') <> nil) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnEditar')).Enabled) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnEditar')).Visible)
  then
  begin
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnEditar')).SetFocus;
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnEditar')).Click;
  end;
end;

procedure TViewPrincipal.AtalhoExcluir;
begin
  if(pgcView.ActivePage <> nil) and
    (pgcView.ActivePage.ControlCount > 0) and
    (pgcView.ActivePage.Controls[0] <> nil) and
    (pgcView.ActivePage.Controls[0].Owner <> nil) and
    (pgcView.ActivePage.Controls[0].Owner.FindComponent('btnExcluir') <> nil) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnExcluir')).Enabled) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnExcluir')).Visible)
  then
  begin
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnExcluir')).SetFocus;
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnExcluir')).Click;
  end;
end;

procedure TViewPrincipal.AtalhoPesquisar(ApenasRefresh: Boolean = False);
begin
  try
    if not ApenasRefresh then
    begin
      if(pgcView.ActivePage <> nil) and
        (pgcView.ActivePage.ControlCount > 0) and
        (pgcView.ActivePage.Controls[0] <> nil) and
        (pgcView.ActivePage.Controls[0].Owner <> nil) and
        (pgcView.ActivePage.Controls[0].Owner.FindComponent('btnPesquisar') <> nil) and
        (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnPesquisar')).Enabled) and
        (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnPesquisar')).Visible)
      then
      begin
        TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnPesquisar')).SetFocus;
        TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnPesquisar')).Click;
      end
      else if (pgcView.ActivePage <> nil) and (pgcView.ActivePage.ControlCount > 0) and (pgcView.ActivePage.Controls[0] <> nil) and (pgcView.ActivePage.Controls[0].Owner <> nil) and (pgcView.ActivePage.Controls[0].Owner.FindComponent('grdRegistros') <> nil) then
      begin
        if TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao <> nil then
          TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao.Atualizar
        else
          TDBGrid(pgcView.ActivePage.Controls[0].Owner.FindComponent('grdRegistros')).DataSource.DataSet.Refresh;
      end;
    end
    else if (pgcView.ActivePage <> nil) and (pgcView.ActivePage.ControlCount > 0) and (pgcView.ActivePage.Controls[0] <> nil) and (pgcView.ActivePage.Controls[0].Owner <> nil) then
    begin
      if TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao <> nil then
        TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao.Atualizar;
    end;
  except
    try
      if TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao <> nil then
        TViewBasicoPadrao(pgcView.ActivePage.Controls[0].Owner).ObjPadrao.Atualizar;
    except
      Exit;
    end;
    Exit;
  end;
end;

procedure TViewPrincipal.AtalhoFechar;
begin
  if(pgcView.ActivePage <> nil) and
    (pgcView.ActivePage.ControlCount > 0) and
    (pgcView.ActivePage.Controls[0] <> nil) and
    (pgcView.ActivePage.Controls[0].Owner <> nil) and
    (pgcView.ActivePage.Controls[0].Owner.FindComponent('btnFechar') <> nil) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnFechar')).Enabled) and
    (TControl(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnFechar')).Visible)
  then
  begin
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnFechar')).SetFocus;
    TBitBtn(pgcView.ActivePage.Controls[0].Owner.FindComponent('btnFechar')).Click;
  end;
end;

end.
