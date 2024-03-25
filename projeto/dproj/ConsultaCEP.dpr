program ConsultaCEP;

uses
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  System.SysUtils,
  System.UITypes,
  Classe.CEP.Web in '..\recursos\funcoes\Classe.CEP.Web.pas',
  Classe.Helpers.ClassePadrao in '..\recursos\funcoes\Classe.Helpers.ClassePadrao.pas',
  Classe.Helpers.Componentes in '..\recursos\funcoes\Classe.Helpers.Componentes.pas',
  Classe.Ini in '..\recursos\funcoes\Classe.Ini.pas',
  Classe.Key in '..\recursos\funcoes\Classe.Key.pas',
  Classe.Query in '..\recursos\funcoes\Classe.Query.pas',
  Classe.Utils in '..\recursos\funcoes\Classe.Utils.pas',
  Constantes in '..\recursos\funcoes\Constantes.pas',
  Classe.Conexao in '..\recursos\conexao\Classe.Conexao.pas',
  View.Informacoes in '..\recursos\informacoes\View.Informacoes.pas' {ViewInformacoes},
  Classe.Padrao.Basico in '..\recursos\padrao\cadastro\classes\Classe.Padrao.Basico.pas',
  Classe.Padrao in '..\recursos\padrao\cadastro\classes\Classe.Padrao.pas',
  DM.Padrao in '..\recursos\padrao\cadastro\model\DM.Padrao.pas' {DMPadrao: TDataModule},
  View.Basico.Padrao in '..\recursos\padrao\cadastro\view\View.Basico.Padrao.pas' {ViewBasicoPadrao},
  View.Cadastro.Padrao in '..\recursos\padrao\cadastro\view\View.Cadastro.Padrao.pas' {ViewCadastroPadrao},
  View.Edicao.Padrao in '..\recursos\padrao\cadastro\view\View.Edicao.Padrao.pas' {ViewEdicaoPadrao},
  DM.Consulta.CEP in '..\pesquisa\cep\model\DM.Consulta.CEP.pas' {DMConsultaCEP: TDataModule},
  View.Consulta.CEP in '..\pesquisa\cep\view\View.Consulta.CEP.pas' {ViewConsultaCEP},
  Classe.FontePagadora in '..\cadastros\Fontes Pagadora\Classe\Classe.FontePagadora.pas',
  DM.FontePagadora in '..\cadastros\Fontes Pagadora\Model\DM.FontePagadora.pas' {DMFontePagadora: TDataModule},
  View.FontePagadora in '..\cadastros\Fontes Pagadora\View\View.FontePagadora.pas' {ViewFontePagadora},
  View.FontePagadoraInsertEdit in '..\cadastros\Fontes Pagadora\View\View.FontePagadoraInsertEdit.pas' {ViewFontePagadoraInsertEdit},
  View.Principal in '..\View.Principal.pas' {ViewPrincipal};

{$R *.res}

begin
  //Gerenciamento MemoryLeak
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  //Conexão ao banco de dados
  try
    Sessao.Conexao := TConexao.Create(Application);
    Sessao.Conexao.Conectar;
  except
    on e: exception do
    begin
      MessageDlg(e.Message,TMsgDlgType.mtError,[TMsgDlgBtn.mbOK],0);
      Application.Terminate;
    end;
  end;

  //Tema persoanlizado do sistema
  TStyleManager.LoadFromFile(TUtils.GetPathSistema+'styles\'+Dark+'.vsf');
  TStyleManager.TrySetStyle(Dark);

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TViewPrincipal, ViewPrincipal);
  Application.Run;
end.
