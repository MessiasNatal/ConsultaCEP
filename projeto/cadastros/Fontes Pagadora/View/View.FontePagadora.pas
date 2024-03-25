unit View.FontePagadora;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Data.DB, Vcl.Menus, System.Actions, Vcl.ActnList, Vcl.StdCtrls, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, Vcl.Imaging.pngimage, View.Cadastro.Padrao;

type
  TViewFontePagadora = class(TViewCadastroPadrao)
    procedure FormCreate(Sender: TObject);
    procedure actPesquisarExecute(Sender: TObject);
  end;

implementation

{$R *.dfm}

uses
  Classe.Helpers.ClassePadrao;

procedure TViewFontePagadora.actPesquisarExecute(Sender: TObject);
begin
  inherited;
  ObjPadrao.FontePagadora.Pesquisar(edtPesquisa.Text);
end;

procedure TViewFontePagadora.FormCreate(Sender: TObject);
begin
  inherited;
  ObjPadrao.FontePagadora.Pesquisar(edtPesquisa.Text);
end;

initialization
  RegisterClasses([TViewFontePagadora]);

end.
