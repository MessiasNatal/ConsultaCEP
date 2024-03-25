unit Consulta.CEP;

interface

uses
  System.Classes, System.JSON, System.Net.URLClient, System.Net.HttpClient, System.NetConsts, System.SysUtils, System.TypInfo,
  REST.Client, REST.Types, Xml.XMLDoc, Xml.XMLIntf, Vcl.Dialogs, System.Generics.Collections, System.Variants;

type
  TConsultaCEP = class;

  TTipoRetorno = (trJSON, trXML);
  TTipoConsulta = (tpCEP, tpEndereco);

  TEventAfterConsulta = procedure(Sender: TConsultaCEP) of object;
  TEventBeforeConsulta = procedure(out Continuar: Boolean) of object;

  TCEP = class(TComponent)
  strict private
    FCEP: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUF: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property UF: string read FUF write FUF;
  end;

  TConsultaCEP = class(TComponent)
  private
    FListaCEP: TList<TCEP>;

    FFalha: Boolean;
    FFalhaDescricao: string;
    FNaoEncontrado: Boolean;
    FTipoRetornoDescricao: string;

    FTipoRetorno: TTipoRetorno;
    FTipoConsulta: TTipoConsulta;

    FOnBeforeConsulta: TEventBeforeConsulta;
    FOnAfterConsulta: TEventAfterConsulta;

    procedure LerJSON(Content: string);
    procedure LerXML(Content: string);

    procedure LerListaJSON(Content: string);
    procedure LerListaXML(Content: string);

    procedure SetTipoRetorno(const Value: TTipoRetorno);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Consultar(const CEP, UF, Localidade, Logradouro: string);

    property Falha: Boolean read FFalha;
    property NaoEncontrado: Boolean read FNaoEncontrado;
    property FalhaDescricao: string read FFalhaDescricao;
    property ListaCEP: TList<TCEP> read FListaCEP;

  published
    property OnBeforeConsulta: TEventBeforeConsulta read FOnBeforeConsulta write FOnBeforeConsulta;
    property OnAfterConsulta: TEventAfterConsulta read FOnAfterConsulta write FOnAfterConsulta;

    property TipoRetorno: TTipoRetorno read FTipoRetorno write SetTipoRetorno;
    property TipoConsulta: TTipoConsulta read FTipoConsulta write FTipoConsulta;
  end;

const
  UrlViaCep = 'https://viacep.com.br/ws/%s/%s/';
  UrlViaCepEndereco = 'https://viacep.com.br/ws/%s/%s/%s/%s';

implementation

{ TConsultaCEP }

constructor TConsultaCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FListaCEP := TList<TCEP>.Create;
  FTipoRetorno := trJSON;
end;

destructor TConsultaCEP.Destroy;
begin
  inherited;
  FListaCEP.Free;
end;

procedure TConsultaCEP.Consultar(const CEP, UF, Localidade, Logradouro: string);
var
  Url: string;
  RestClient: TRESTClient;
  RestRequest: TRESTRequest;
  RestResponse: TRESTResponse;
  Continuar: Boolean;
begin
  FNaoEncontrado := False;
  FFalha := False;

  if Assigned(FOnBeforeConsulta) then
    FOnBeforeConsulta(Continuar);

  if not Continuar then
    Exit;

  FListaCEP.Clear;

  case FTipoConsulta of
    tpCEP:
    begin
      if Length(CEP)<>8 then
      begin
        MessageDlg('CEP incorreto.',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
        Exit;
      end;
      Url := Format(UrlViaCep,[CEP,FTipoRetornoDescricao]);
    end;
    tpEndereco:
    begin
      if (Length(UF)<2) or (Length(Localidade)<3) or (Length(Logradouro)<3) then
      begin
        MessageDlg('Estado/Localidade/Logradouro incorreto.',TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
        Exit;
      end;
      Url := Format(UrlViaCepEndereco,[UF,Localidade,Logradouro,FTipoRetornoDescricao]);
    end;
  end;

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
      on e: Exception do
      begin
        FFalha := True;
        FFalhaDescricao := e.Message;
      end;
    end;

    case FTipoConsulta of
      tpCEP:
        case FTipoRetorno of
          trJSON:
            LerJSON(RestResponse.Content);
          trXML:
            LerXML(RestResponse.Content);
        end;
      tpEndereco:
        case FTipoRetorno of
          trJSON:
            LerListaJSON(RestResponse.Content);
          trXML:
            LerListaXML(RestResponse.Content);
        end;
    end;

    if Assigned(FOnAfterConsulta) then
      FOnAfterConsulta(Self);

  finally
    FreeAndNil(RestClient);
  end;
end;

procedure TConsultaCEP.LerJSON(Content: string);
var
  JSON: TJSONObject;
  Lista: TCEP;
begin
  if FFalha then
    Exit;

  JSON := TJSONObject.ParseJSONValue(Content) as TJSONObject;
  try
    FNaoEncontrado :=False;
    if Assigned(JSON.Values['erro']) then
      FNaoEncontrado := (JSON.GetValue('erro').Value = 'true');

    if (FNaoEncontrado) then
      Exit;

    Lista := TCEP.Create(Self);
    Lista.CEP := StringReplace(JSON.GetValue('cep').Value,'-','',[rfReplaceAll]);
    Lista.Logradouro := JSON.GetValue('logradouro').Value;
    Lista.Complemento := JSON.GetValue('complemento').Value;
    Lista.Bairro := JSON.GetValue('bairro').Value;
    Lista.Localidade := JSON.GetValue('localidade').Value;
    Lista.UF := JSON.GetValue('uf').Value;

    FListaCEP.Add(Lista);

  finally
    JSON.Free;
  end;
end;

procedure TConsultaCEP.LerXML(Content: string);
var
  XML: TXMLDocument;
  Lista: TCEP;
begin
  if FFalha then
    Exit;

  XML := TXMLDocument.Create(Self);
  try
    XML.LoadFromXML(Content);

    FNaoEncontrado :=False;
    if Assigned(XML.DocumentElement.ChildNodes.FindNode('erro')) then
      FNaoEncontrado := (XML.DocumentElement.ChildValues['erro'] = 'true');

    if (FNaoEncontrado) then
      Exit;

    Lista := TCEP.Create(Self);
    Lista.CEP := StringReplace(VarToStr(XML.DocumentElement.ChildValues['cep']),'-','',[rfReplaceAll]);
    Lista.Logradouro := VarToStr(XML.DocumentElement.ChildValues['logradouro']);
    Lista.Complemento := VarToStr(XML.DocumentElement.ChildValues['complemento']);
    Lista.Bairro := VarToStr(XML.DocumentElement.ChildValues['bairro']);
    Lista.Localidade := VarToStr(XML.DocumentElement.ChildValues['localidade']);
    Lista.UF := VarToStr(XML.DocumentElement.ChildValues['uf']);

    FListaCEP.Add(Lista);

  finally
    XML.Free;
  end;
end;

procedure TConsultaCEP.LerListaJSON(Content: string);
var
  JSON: TJSONArray;
  Lista: TCEP;
  i: Integer;
begin
  if FFalha then
    Exit;

  JSON := TJSONObject.ParseJSONValue(Content) as TJSONArray;
  try
    for i := 0 to Pred(JSON.Count) do
    begin
      Lista := TCEP.Create(Self);
      Lista.CEP := StringReplace(TJSONObject(JSON.Items[i]).GetValue('cep').Value,'','',[rfReplaceAll]);
      Lista.Logradouro := TJSONObject(JSON.Items[i]).GetValue('logradouro').Value;
      Lista.Complemento := TJSONObject(JSON.Items[i]).GetValue('complemento').Value;
      Lista.Bairro := TJSONObject(JSON.Items[i]).GetValue('bairro').Value;
      Lista.Localidade := TJSONObject(JSON.Items[i]).GetValue('localidade').Value;
      Lista.UF := TJSONObject(JSON.Items[i]).GetValue('uf').Value;

      FListaCEP.Add(Lista);
    end;

  finally
    JSON.Free;
  end;
end;

procedure TConsultaCEP.LerListaXML(Content: string);
const
  TagEnderecos = 0;
var
  XML: TXMLDocument;
  NodeList: IXMLNodeList;
  Lista: TCEP;
  i: Integer;
begin
  if FFalha then
    Exit;

  XML := TXMLDocument.Create(Self);
  try
    XML.LoadFromXML(Content);
    XML.Active := True;

    NodeList := XML.DocumentElement.ChildNodes[TagEnderecos].ChildNodes;

    for i := 0 to Pred(NodeList.Count) do
    begin
      Lista := TCEP.Create(Self);

      Lista.CEP := StringReplace(VarToStr(NodeList[i].ChildValues['cep']),'','',[rfReplaceAll]);
      Lista.Logradouro := VarToStr(NodeList[i].ChildValues['logradouro']);
      Lista.Complemento := VarToStr(NodeList[i].ChildValues['complemento']);
      Lista.Bairro := VarToStr(NodeList[i].ChildValues['bairro']);
      Lista.Localidade := VarToStr(NodeList[i].ChildValues['localidade']);
      Lista.UF := VarToStr(NodeList[i].ChildValues['uf']);

      FListaCEP.Add(Lista);
    end;

  finally
    XML.Free;
  end;
end;

procedure TConsultaCEP.SetTipoRetorno(const Value: TTipoRetorno);
begin
  FTipoRetorno := Value;
  FTipoRetornoDescricao:=GetEnumName(TypeInfo(TTipoRetorno),Integer(FTipoRetorno));
  FTipoRetornoDescricao:=Copy(FTipoRetornoDescricao,3,Length(FTipoRetornoDescricao));
  FTipoRetornoDescricao:=LowerCase(FTipoRetornoDescricao);
end;

{ TCEP }

constructor TCEP.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TCEP.Destroy;
begin
  inherited;
end;

end.
