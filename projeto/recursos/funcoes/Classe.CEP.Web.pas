unit Classe.CEP.Web;

interface

uses
  System.JSON, System.Net.URLClient, System.Net.HttpClient, System.NetConsts, REST.Client, REST.Types, System.SysUtils;

type
  TCEPWeb = class
  private
    FCEP: string;
    FLogradouro: string;
    FBairro: string;
    FCidade: string;
    FUF: string;
    FEstado: string;
    FFalha: Boolean;
    FNaoEncontrado: Boolean;
  public
    procedure Consultar(const CEP: string);
    property CEP: string read FCEP;
    property Logradouro: string read FLogradouro;
    property Bairro: string read FBairro;
    property Cidade: string read FCidade;
    property UF: string read FUF;
    property Estado: string read FEstado;
    property Falha: Boolean read FFalha;
    property NaoEncontrado: Boolean read FNaoEncontrado;
  end;

const
  UrlViaCep = 'https://viacep.com.br/ws/%s/%s/';
  ConsultaJSON = 'json';
  ConsultaXML= 'xml';

implementation

{ TCEPWeb }

procedure TCEPWeb.Consultar(const CEP: string);
var
  Url: string;
  RestClient: TRESTClient;
  RestRequest: TRESTRequest;
  RestResponse: TRESTResponse;
  JResponse: TJSONObject;
begin
  Url := Format(UrlViaCep,[CEP,ConsultaJSON]);

  RestClient := TRESTClient.Create(url);
  RestRequest := TRESTRequest.Create(RestClient);
  RestResponse := TRESTResponse.Create(RestRequest);
  try
    RestRequest.Client := RestClient;
    RestRequest.Response := RestResponse;
    RestRequest.Method := TRESTRequestMethod.rmGET;

    try
      RestRequest.Execute;
      FFalha := (RestResponse.StatusCode <> 200);
    except
      FFalha := True;
    end;

    if FFalha then
      Exit;

    JResponse := TJSONObject.ParseJSONValue(RestResponse.Content) as TJSONObject;

    try
      FNaoEncontrado := False;
      if (JResponse.GetValue('erro').Value = 'true') then
        FNaoEncontrado := True;
    except
    end;

    if (FFalha) or (FNaoEncontrado) then
      Exit;

    FCEP := JResponse.GetValue('cep').Value;
    FLogradouro := JResponse.GetValue('logradouro').Value;
    FBairro := JResponse.GetValue('bairro').Value;
    FCidade := JResponse.GetValue('localidade').Value;
    FUF := JResponse.GetValue('uf').Value;

  finally
    FreeAndNil(RestClient);
    FreeAndNil(JResponse);
  end;
end;

end.
