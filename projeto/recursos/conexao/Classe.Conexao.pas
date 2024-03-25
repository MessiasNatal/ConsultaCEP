unit Classe.Conexao;

interface

uses
  System.Classes, System.SysUtils, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TConexao = class(TComponent)
  strict private
    FConnection: TFDConnection;
    FDPhysFBDriverLink: TFDPhysFBDriverLink;
    procedure CarregarParametros;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property Connection: TFDConnection read FConnection;

    procedure Conectar;
  end;

implementation

uses
  Classe.Ini, Constantes;

{ TConexao }

constructor TConexao.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FDPhysFBDriverLink := TFDPhysFBDriverLink.Create(Self);
  FConnection := TFDConnection.Create(Self);

  FConnection.Name := 'ConnectionPrincipal';
  FConnection.LoginPrompt := False;
  CarregarParametros;
end;

destructor TConexao.Destroy;
begin

  inherited;
end;

procedure TConexao.CarregarParametros;
const
  Driver = 'FB';
  CharSet = 'WIN1252';
begin
  FConnection.Params.AddPair('DriverID',Driver);
  FConnection.Params.AddPair('CharacterSet',CharSet);

  FConnection.Params.AddPair('Database',TIni.GetPathDataBase);
  FConnection.Params.AddPair('Server',TIni.GetHostDataBase);
  FConnection.Params.AddPair('CharacterSet',TIni.GetPortaDataBase.ToString);
  FConnection.Params.AddPair('Port',TIni.GetPortaDataBase.ToString);
  FConnection.Params.AddPair('LibrayName',TIni.GetLibDataBase);

  FConnection.Params.AddPair('User_Name',USUARIODATABASE);
  FConnection.Params.AddPair('PassWord',SENHADATABASE);
end;

procedure TConexao.Conectar;
begin
  try
    FConnection.Open;
  except
    on e: exception do
      raise Exception.Create('Falha ao conectar ao banco de dados'+#13#10+#13#10+'Detalhes:'+#13#10+e.Message);
  end;
end;

end.
