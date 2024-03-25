unit View.Consulta.CEP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  View.Basico.Padrao, Vcl.AppEvnts, Vcl.ExtCtrls, Consulta.CEP, Vcl.StdCtrls, Vcl.DBCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Vcl.Buttons,
  DM.Consulta.CEP;

type
  TViewConsultaCEP = class(TViewBasicoPadrao)
    pnlPrincipal: TPanel;
    ConsultaCEP: TConsultaCEP;
    pnlFiltro: TPanel;
    rgTipoRetorno: TRadioGroup;
    gbConsultaEndereco: TGroupBox;
    gbConsultaCEP: TGroupBox;
    edtConsultaCEP: TEdit;
    grdRegistros: TDBGrid;
    dsPadrao: TDataSource;
    btnPesquisar: TBitBtn;
    gbRealizar: TGroupBox;
    lbRealizar: TLabel;
    edtLogradouro: TEdit;
    edtLocalidade: TEdit;
    lbEstado: TLabel;
    cbUF: TComboBox;
    lbLocalidade: TLabel;
    lbLogradouro: TLabel;
    procedure btnPesquisarClick(Sender: TObject);
    procedure ConsultaCEPBeforeConsulta(out Continuar: Boolean);
    procedure ConsultaCEPAfterConsulta(Sender: TConsultaCEP);
    procedure grdRegistrosDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtConsultaCEPChange(Sender: TObject);
    procedure edtConsultaEnderecoChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtConsultaCEPClick(Sender: TObject);
  private
    DMConsultaCEP: TDMConsultaCEP;
    procedure InserirDados(CEP, Logradouro, Complemento, Bairro, Localidade, UF: string);
    procedure LimparDataSet;
  end;

implementation

uses
  Classe.Utils;

{$R *.dfm}

procedure TViewConsultaCEP.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  Action := TCloseAction.caHide;
end;

procedure TViewConsultaCEP.FormCreate(Sender: TObject);
begin
  inherited;
  DMConsultaCEP := TDMConsultaCEP.Create(Self);
  dsPadrao.DataSet := DMConsultaCEP.memPadrao;
end;

procedure TViewConsultaCEP.FormShow(Sender: TObject);
begin
  inherited;
  edtConsultaCEP.SetFocus;
  ConsultaCEP.TipoConsulta := tpCEP;
  lbRealizar.Caption := 'Consulta por CEP';
end;

procedure TViewConsultaCEP.grdRegistrosDblClick(Sender: TObject);
begin
  inherited;
  if dsPadrao.DataSet.IsEmpty then
    ModalResult := mrCancel
  else
    ModalResult := mrOk;
end;

procedure TViewConsultaCEP.btnPesquisarClick(Sender: TObject);
begin
  inherited;
  ConsultaCEP.TipoRetorno := TTipoRetorno(rgTipoRetorno.ItemIndex);
  case ConsultaCEP.TipoConsulta of
    tpCEP:
      ConsultaCEP.Consultar(edtConsultaCEP.Text,'','','');
    tpEndereco:
      ConsultaCEP.Consultar(edtConsultaCEP.Text,cbUF.Text,edtLocalidade.Text,edtLogradouro.Text);
  end;
end;

procedure TViewConsultaCEP.ConsultaCEPAfterConsulta(Sender: TConsultaCEP);
var
  i: Integer;
begin
  inherited;
  if Sender.NaoEncontrado then
  begin
    MessageDlg('Não foi possível encontrar.',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
    if MessageBox(0,'Deseja buscar pelo Endereço ?','Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_YES then
    begin
      edtConsultaCEP.Clear;
      cbUF.SetFocus;
    end;
    Exit;
  end;
  if Sender.Falha then
  begin
    MessageDlg('Não foi possível encontrar.' + sLineBreak + Sender.FalhaDescricao,TMsgDlgType.mtError,[TMsgDlgBtn.mbOK],0);
    Exit;
  end;
  case ConsultaCEP.TipoConsulta of
    tpCEP:
      InserirDados(Sender.ListaCEP.Items[0].CEP,
                   Sender.ListaCEP.Items[0].Logradouro,
                   Sender.ListaCEP.Items[0].Complemento,
                   Sender.ListaCEP.Items[0].Bairro,
                   Sender.ListaCEP.Items[0].Localidade,
                   Sender.ListaCEP.Items[0].UF);
    tpEndereco:
    begin
      dsPadrao.DataSet.DisableControls;
      try
        for i := 0 to Pred(Sender.ListaCEP.Count) do
          InserirDados(Sender.ListaCEP.Items[i].CEP,
                       Sender.ListaCEP.Items[i].Logradouro,
                       Sender.ListaCEP.Items[i].Complemento,
                       Sender.ListaCEP.Items[i].Bairro,
                       Sender.ListaCEP.Items[i].Localidade,
                       Sender.ListaCEP.Items[i].UF);
      finally
        dsPadrao.DataSet.EnableControls;
      end;
    end;
  end;
end;

procedure TViewConsultaCEP.ConsultaCEPBeforeConsulta(out Continuar: Boolean);
var
  Lista: TList;
  i: Integer;
begin
  inherited;
  Continuar := True;

  LimparDataSet;

  case ConsultaCEP.TipoConsulta of
    tpCEP:
    begin
      Lista := TList.Create;
      try
        if TUtils.CEPExiste(edtConsultaCEP.Text,Lista) then
          Continuar := (MessageBox(0,'CEP já existe na base de dados, deseja utilizá-lo ?','Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_NO);
        if not Continuar then
          InserirDados(TStringList(Lista[i]).Values['cep'],
                       TStringList(Lista[i]).Values['logradouro'],
                       TStringList(Lista[i]).Values['complemento'],
                       TStringList(Lista[i]).Values['bairro'],
                       TStringList(Lista[i]).Values['localidade'],
                       TStringList(Lista[i]).Values['uf']);
      finally
        for i := 0 to Pred(Lista.Count) do
          TStringList(Lista[i]).Free;
        Lista.Free;
      end;
    end;
    tpEndereco:
    begin
      Lista := TList.Create;
      try
        if TUtils.EnderecoExiste(cbUF.Text,edtLocalidade.Text,edtLogradouro.Text,Lista) then
          Continuar := (MessageBox(0,'Endereço já existe na base de dados, deseja utilizá-lo ?','Informação',MB_ICONQUESTION+MB_TASKMODAL+MB_YESNO)=ID_NO);
        if not Continuar then
          for i := 0 to Pred(Lista.Count) do
            InserirDados(TStringList(Lista[i]).Values['cep'],
                         TStringList(Lista[i]).Values['logradouro'],
                         TStringList(Lista[i]).Values['complemento'],
                         TStringList(Lista[i]).Values['bairro'],
                         TStringList(Lista[i]).Values['localidade'],
                         TStringList(Lista[i]).Values['uf']);
      finally
        for i := 0 to Pred(Lista.Count) do
          TStringList(Lista[i]).Free;
        Lista.Free;
      end;
    end;
  end;
end;

procedure TViewConsultaCEP.edtConsultaCEPChange(Sender: TObject);
begin
  inherited;
  LimparDataSet;
  ConsultaCEP.TipoConsulta := tpCEP;
  lbRealizar.Caption := 'Consulta por CEP';
end;

procedure TViewConsultaCEP.edtConsultaCEPClick(Sender: TObject);
begin
  inherited;
  cbUF.ItemIndex := -1;
  edtLocalidade.Clear;
  edtLogradouro.Clear;
end;

procedure TViewConsultaCEP.edtConsultaEnderecoChange(Sender: TObject);
begin
  inherited;
  LimparDataSet;
  edtConsultaCEP.Clear;
  ConsultaCEP.TipoConsulta := tpEndereco;
  lbRealizar.Caption := 'Consulta por ENDEREÇO';
end;

procedure TViewConsultaCEP.InserirDados(CEP, Logradouro, Complemento, Bairro, Localidade, UF: string);
begin
  dsPadrao.DataSet.Append;
  dsPadrao.DataSet.FieldByName('cep').AsString := CEP;
  dsPadrao.DataSet.FieldByName('logradouro').AsString := Logradouro;
  dsPadrao.DataSet.FieldByName('complemento').AsString := Complemento;
  dsPadrao.DataSet.FieldByName('bairro').AsString := Bairro;
  dsPadrao.DataSet.FieldByName('localidade').AsString := Localidade;
  dsPadrao.DataSet.FieldByName('uf').AsString := UF;
  dsPadrao.DataSet.Post;
end;

procedure TViewConsultaCEP.LimparDataSet;
begin
  dsPadrao.DataSet.Close;
  dsPadrao.DataSet.Open;
end;

end.
