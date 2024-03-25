unit View.Informacoes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.Buttons, Winapi.ShellAPI, Vcl.DBCtrls, Vcl.Clipbrd, Vcl.ComCtrls, System.UITypes, System.Math,
  Vcl.TitleBarCtrls;

type
  TViewInformacoes = class(TForm)
    TitleBarCustom: TTitleBarPanel;
    pnlSistema: TPanel;
    pnlFechar: TPanel;
    imgFechar: TImage;
    pnlAtencao: TPanel;
    memInfo: TMemo;
    pnlMaximizar: TPanel;
    imgMaximizar: TImage;
    imgAtencao: TImage;
    procedure btnCopiarDetalhesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblDetalheDblClick(Sender: TObject);
    procedure imgFecharClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure imgMaximizarClick(Sender: TObject);
  end;

var
  ViewInformacoes: TViewInformacoes;

implementation

uses
  Constantes;

{$R *.dfm}

procedure TViewInformacoes.btnCopiarDetalhesClick(Sender: TObject);
begin
  Clipboard.AsText := memInfo.Text;
end;

procedure TViewInformacoes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := Cafree;
end;

procedure TViewInformacoes.FormCreate(Sender: TObject);
begin
  Caption := '';
  BorderIcons := [];
  memInfo.Lines.Clear;
  memInfo.Font.Color := $0042A0FF;
end;

procedure TViewInformacoes.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TViewInformacoes.imgFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TViewInformacoes.imgMaximizarClick(Sender: TObject);
begin
  if WindowState = wsMaximized then
    WindowState := TWindowState.wsNormal
  else
    WindowState := TWindowState.wsMaximized
end;

procedure TViewInformacoes.lblDetalheDblClick(Sender: TObject);
begin
  Clipboard.AsText := memInfo.Text;
end;

end.
