unit Constantes;

interface

uses
  Classe.Conexao;

const
  {**************** SISTEMA **************}
  App = 'MVP by Messias Antônio Natal';
  Versao = '1.0.0';

  {******************** CORES ********************}
  VERMELHO = $008C9DED;
  AMARELO = $008CDEED;
  VERDE = $008CED9A;
  AZUL = $00EDC78C;
  LARANJA = $0080BFFF;
  SELECAO_LINHA_GRID = $00805240;
  COR_TEMA = $0050311C;
  COR_ALERTA = $0050B8FF;

  {******************** CLASSE PADRÃO ********************}
  FIELDNAME_IdSetor = 'id_setor';
  FIELDNAME_IdEmpresa = 'id_empresa';
  FIELDNAME_DATALANCAMENTO = 'data_lancamento';
  FIELDNAME_ID_Usuario_INSERCAO = 'id_Usuario_insercao';
  FIELDNAME_DATA_INSERCAO = 'data_insercao';
  FIELDNAME_ID_Usuario_EDICAO = 'id_Usuario_edicao';
  FIELDNAME_DATA_EDICAO = 'data_edicao';
  FIELDNAME_DATA_EMISSAO = 'data_emissao';
  FIELDNAME_DATA_MOVIMENTACAO = 'data_movimentacao';
  FIELDNAME_DATA_INICIAL = 'data_inicial';
  FIELDNAME_DATA_FINAL = 'data_final';

  {******************* TEMAS *********************}
  Dark = 'Dark';

  {***************** BANCO DE DADOS **************}
  USUARIODATABASE = 'SYSDBA';
  SENHADATABASE = 'masterkey';

  {******************** SESSÃO DO SISTEMA ********************}
var
  Sessao: record
    Conexao: TConexao;
    IdSetor: Integer;
    NomeSetor: string;
    IdEmpresa: Integer;
    NomeEmpresa: string;
    CnpjEmpresa: string;
    EnderecoEmpresa: string;
    IdUsuario: Integer;
    Usuario: string;
  end;

implementation

end.
