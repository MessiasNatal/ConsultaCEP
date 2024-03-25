unit View.FontePagadoraInsertEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, View.Edicao.Padrao,
  System.ImageList, Vcl.ImgList, Data.DB, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Mask, Vcl.DBCtrls, Vcl.Grids, Vcl.DBGrids;

type
  TViewFontePagadoraInsertEdit = class(TViewEdicaoPadrao)
    pnlDadosPessoais: TPanel;
    lblDados: TLabel;
    lblNome: TLabel;
    lblcpfcnpj: TLabel;
    lblLogadouro: TLabel;
    lblCEP: TLabel;
    lblEndereco: TLabel;
    lblNumero: TLabel;
    lblBairro: TLabel;
    edtNome: TDBEdit;
    edtCpfCnpj: TDBEdit;
    edtCep: TDBEdit;
    edtEndereco: TDBEdit;
    edtNumero: TDBEdit;
    edtBairro: TDBEdit;
    rgTipo: TDBRadioGroup;
    lbComplemento: TLabel;
    edtComplemento: TDBEdit;
    edtLocalidade: TDBEdit;
    lbLocalidade: TLabel;
    edtUF: TDBEdit;
    lbUF: TLabel;
    btnCEP: TSpeedButton;
    procedure btnCEPClick(Sender: TObject);
  end;


implementation

uses
  View.Consulta.CEP, Classe.Utils;

{$R *.dfm}

{ TViewFontesPagadoraInsertEdit }

procedure TViewFontePagadoraInsertEdit.btnCEPClick(Sender: TObject);
var
  ViewConsultaCEP: TViewConsultaCEP;
  UtilizarEnderecoConsultado: Boolean;
begin
  inherited;
  ViewConsultaCEP := TViewConsultaCEP.Create(Self);
  try
    ViewConsultaCEP.ShowModal;
    UtilizarEnderecoConsultado := (ViewConsultaCEP.ModalResult = mrOk) and (MessageBox(0,'Confirma utilização do endereço ?','Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_YES);
    if UtilizarEnderecoConsultado then
    begin
      ObjPadrao.dSetPadrao.FieldByName('cep').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('cep').AsString;
      ObjPadrao.dSetPadrao.FieldByName('logradouro').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('logradouro').AsString;
      ObjPadrao.dSetPadrao.FieldByName('complemento').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('complemento').AsString;
      ObjPadrao.dSetPadrao.FieldByName('bairro').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('bairro').AsString;
      ObjPadrao.dSetPadrao.FieldByName('localidade').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('localidade').AsString;
      ObjPadrao.dSetPadrao.FieldByName('uf').AsString := ViewConsultaCEP.dsPadrao.DataSet.FieldByName('uf').AsString;
      edtNumero.SetFocus;
    end;
  finally
    ViewConsultaCEP.Free;
  end;
end;

initialization
  RegisterClasses([TViewFontePagadoraInsertEdit]);

end.
