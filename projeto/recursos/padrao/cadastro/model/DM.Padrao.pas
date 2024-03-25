unit DM.Padrao;

interface

uses
  System.SysUtils, System.Classes, Data.DB, System.Variants, Vcl.Dialogs, Vcl.AppEvnts, FireDAC.Comp.Client;

type
  TDMPadrao = class(TDataModule)
    AppEvents: TApplicationEvents;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure AppEventsException(Sender: TObject; E: Exception);
  protected
    FTabela: string;
    procedure FormatarCampos(DataSet: TDataSet);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses
  Classe.Query, Classe.Ini, Classe.Helpers.Componentes, Classe.Utils, Constantes;

{$R *.dfm}

procedure TDMPadrao.AppEventsException(Sender: TObject; E: Exception);
begin
  if E.Message <> 'Operation aborted' then
    if Pos('Invalid input', E.Message) > 0 then
      raise Exception.Create('Valor Digitado Inválido.')
    else
    if Pos('is not a valid time', E.Message) > 0 then
      raise Exception.Create('Horário Inválido.')
    else
      TUtils.MsgInfo(E.Message);
  Abort;
end;

procedure TDMPadrao.DataModuleDestroy(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(Self.ComponentCount) do
    if Self.Components[i] is TFDQuery then
    begin
      TFDQuery(Self.Components[i]).Close;
      TFDQuery(Self.Components[i]).Connection := nil;
    end;
end;

procedure TDMPadrao.DataModuleCreate(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to Pred(Self.ComponentCount) do
    if Self.Components[i] is TFDQuery then
    begin
      TFDQuery(Self.Components[i]).Connection := Sessao.Conexao.Connection;
      TFDQuery(Self.Components[i]).CachedUpdates := True;
      FormatarCampos(TFDQuery(Self.Components[i]));
    end;
end;

procedure TDMPadrao.FormatarCampos(DataSet: TDataSet);
const
  sqlCampos = 'select '+
              '  rdb$field_name as column_name, '+
              '  rdb$description as column_comment '+
              'from '+
              '  rdb$relation_fields '+
              'where '+
              '  rdb$relation_name = upper(%s) ';

  function GetDescricaoCampo(pDataSet: TDataSet; pCampo: string): string;
  begin
    pDataSet.Filtered := False;
    pDataSet.Filter := Format('column_name = %s',[QuotedStr(pCampo)]);
    pDataSet.Filtered:=True;
    Result := pDataSet.FieldByName('column_comment').AsString;
  end;

  procedure DefinirDescricaoCampos;
  var
    DescricaoCampo: string;
    x: Integer;
  begin
    with TQUERY.Create(Format(sqlCampos,[QuotedStr(FTabela)])) do
      try
        qy.Open;
        for x := 0 to Pred(DataSet.FieldCount) do
        begin
          DescricaoCampo := GetDescricaoCampo(qy,DataSet.Fields[x].FieldName);
          if DescricaoCampo <> '' then
            DataSet.Fields[x].DisplayLabel := DescricaoCampo;
        end;
      finally
        Free;
      end;
  end;

var
  ListaDescricaoCampo: TStringList;
  x,y: Integer;
begin
  DefinirDescricaoCampos;

  ListaDescricaoCampo := TStringList.Create;
  try
    with ListaDescricaoCampo do
    begin
      AddPair('dsc_cidade','Cidade');
      AddPair('dsc_estado','Estado');
      AddPair('dsc_empresa','Empresa');
    end;
    for x := 0 to Pred(DataSet.FieldCount) do
    begin
      DataSet.Fields[x].ReadOnly := False;
      if (LowerCase(DataSet.Fields[x].FieldName) = 'key') then
      begin
        DataSet.Fields[x].Required := False;
        DataSet.Fields[x].ReadOnly := True;
        DataSet.Fields[x].ProviderFlags := [pfInUpdate,pfInWhere,pfInKey];
      end;
      if (LowerCase(DataSet.Fields[x].DisplayLabel) = 'id') then
      begin
        DataSet.Fields[x].Required := False;
        DataSet.Fields[x].ReadOnly := False;
        DataSet.Fields[x].ProviderFlags := [pfInUpdate,pfInWhere,pfInKey];
      end;
      if (LowerCase(DataSet.Fields[x].FieldName) = 'data_edicao') then
        DataSet.Fields[x].Required := False;
      if LowerCase(DataSet.Fields[x].FieldName.Substring(0,4)) = 'dsc_' then
        DataSet.Fields[x].Required := False;
      if LowerCase(DataSet.Fields[x].FieldName.Substring(0,4)) = 'sum_' then
        DataSet.Fields[x].Required := False;
      if DataSet.Fields[x].DataType = ftTime then
        DataSet.Fields[x].EditMask := '!90:00;1;_';
      if (DataSet.Fields[x].DataType = ftDate) or (DataSet.Fields[x].DataType = ftDateTime) then
        DataSet.Fields[x].EditMask := '!99/99/0000;1;_';
      if (DataSet.Fields[x].DataType = ftFloat) and (DataSet.Fields[x].Tag = 0) then
        TFloatField(DataSet.Fields[x]).Currency := True;
      for y := 0 to Pred(ListaDescricaoCampo.Count) do
        if DataSet.FindField(ListaDescricaoCampo.Names[y]) <> nil then
          DataSet.FindField(ListaDescricaoCampo.Names[y]).DisplayLabel := ListaDescricaoCampo.Values[ListaDescricaoCampo.Names[y]];
    end;
  finally
    ListaDescricaoCampo.Free;
  end;
end;

end.
