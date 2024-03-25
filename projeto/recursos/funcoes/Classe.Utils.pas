unit Classe.Utils;

interface

uses
  Vcl.Forms, Vcl.Dialogs, System.SysUtils, View.Informacoes, Data.DB, System.UITypes, System.AnsiStrings, System.Classes;

type
  TUtils = class
    class function getCaminhoParametro: string;
    class function GetPathSistema: string;
    class procedure MsgInfo(Value: string);
    class procedure Mensagem(Value: string);
    class procedure HabilitarDataSets(DataSets: array of TDataSet);
    class procedure DesabilitarDataSets(DataSets: array of TDataSet);
    class function ifThen(Condicao: Boolean; RetornoTrue, RetornoFalse: string): string;
    class procedure AbrirDataSets(pdSets: array of TDataSet);
    class function ValidaCampos(pDataSet: TDataSet): Boolean; overload;
    class function ValidaCPF(pValue : string): Boolean;
    class function ValidaCNPJ(pValue : string): Boolean;
    class function CEPExiste(CEP: string; out Lista: TList): Boolean;
    class function EnderecoExiste(UF, Localidade, Logradouro: string; out ListaRetorno: TList): Boolean;
  end;

implementation

uses
  Classe.Helpers.Componentes, Classe.Query;

{ TUtils }

class procedure TUtils.AbrirDataSets(pdSets: array of TDataSet);
var
  i: Integer;
begin
  for i := 0 to High(pdSets) do
    try
      if pdSets[i].Query.Connection = nil then
        raise Exception.Create('Conexão não esta definida para a query');
      pdSets[i].Open;
    except
      on e: Exception do
        raise Exception.Create('Falha ao abrir dataset' + sLineBreak + e.Message);
    end;
end;

class procedure TUtils.DesabilitarDataSets(DataSets: array of TDataSet);
var
  i: Integer;
begin
  for i := 0 to High(DataSets) do
  begin
    DataSets[i].First;
    DataSets[i].DisableControls;
  end;
end;

class function TUtils.getCaminhoParametro: string;
begin
  Result := Concat(ExtractFilePath(Application.ExeName),'parametros\config.ini');
  if not FileExists(Result) then
    raise Exception.Create('Arquivo de paramêtros do sistema não existe, Contate o suporte técnico');
end;

class function TUtils.GetPathSistema: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

class procedure TUtils.HabilitarDataSets(DataSets: array of TDataSet);
var
  i: Integer;
begin
  for i := 0 to High(DataSets) do
  begin
    DataSets[i].First;
    DataSets[i].EnableControls;
  end;
end;

class function TUtils.ifThen(Condicao: Boolean; RetornoTrue, RetornoFalse: string): string;
begin
  Result := RetornoFalse;
  if Condicao then
    Result := RetornoTrue;
end;

class procedure TUtils.Mensagem(Value: string);
begin
  MessageDlg(Value,TMsgDlgType.mtWarning,[TMsgDlgBtn.mbOK],0);
end;

class procedure TUtils.MsgInfo(Value: string);
begin
  with TViewInformacoes.Create(nil) do
    try
      memInfo.Lines.Add(Value);
      Showmodal;
    finally
      Free;
    end;
end;

class function TUtils.validaCampos(pDataSet: TDataSet): Boolean;
var
  Cont: integer;
  Campos : string;
  Mensagem: string;
begin
  Result := True;
  Campos := '';
  for Cont := 0 to Pred(pDataSet.FieldCount) do
  begin
    if pDataSet.Fields[Cont].Required then
    begin
      if pDataSet.Fields[Cont].DataType = ftWideString then
      begin
        if (pDataSet.Fields[Cont].IsNull) or (trim(pDataSet.fields[Cont].AsString) = '') then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result := False;
        end;
      end
      else
      if (pDataSet.Fields[Cont].DataType = ftInteger) then
      begin
        if (pDataSet.Fields[Cont].IsNull) or (pDataSet.fields[Cont].AsInteger = 0) then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result := False;
        end;
      end
      else
      if (pDataSet.fields[Cont].DataType = ftCurrency) then
      begin
        if (pDataSet.Fields[Cont].IsNull) or (pDataSet.fields[Cont].AsCurrency = 0) then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result := False;
        end;
      end
      else
      if (pDataSet.fields[Cont].DataType = ftFloat) then
      begin
        if (pDataSet.Fields[Cont].IsNull) or (pDataSet.fields[Cont].AsFloat = 0) then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result := False;
        end;
      end
      else
      if pDataSet.Fields[Cont].DataType = ftFMTBcd then
      begin
        if (pDataSet.Fields[Cont].IsNull) or (pDataSet.fields[Cont].AsFloat = 0) then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result := False;
        end;
      end
      else
      begin
        if (pDataSet.Fields[Cont].IsNull) or (trim(pDataSet.fields[Cont].AsString) = '') then
        begin
          Campos := Campos + ' - '+  pDataSet.Fields[Cont].DisplayLabel + sLineBreak;
          Result:=False;
        end;
      end;
    end;
  end;
  if not Result then
  begin
    Mensagem := 'Favor preencher o(s) seguinte(s) campo(s) obrigatório(s) ' + sLineBreak + Campos;
    MsgInfo(Mensagem);
  end;
end;

class function TUtils.ValidaCNPJ(pValue: string): Boolean;
var
  cnpj: string;
  dg1, dg2: integer;
  x, total: integer;
  ret: boolean;
begin
  Result := False;
  if pValue='' then
    Exit;
  ret:=False;
  cnpj:='';
  if Length(pValue) = 18 then
    if (Copy(pValue,3,1) + Copy(pValue,7,1) + Copy(pValue,11,1) + Copy(pValue,16,1) = '../-') then
      begin
        cnpj:=Copy(pValue,1,2) + Copy(pValue,4,3) + Copy(pValue,8,3) + Copy(pValue,12,4) + Copy(pValue,17,2);
        ret:=True;
      end;
  if Length(pValue) = 14 then
  begin
    cnpj:=pValue;
    ret:=True;
  end;
  if ret then
  begin
    try
      total:=0;
      for x:=1 to 12 do
      begin
        if x < 5 then
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (6 - x))
        else
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (14 - x));
      end;
      dg1:=11 - (total mod 11);
      if dg1 > 9 then
        dg1:=0;
      total:=0;
      for x:=1 to 13 do
      begin
        if x < 6 then
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (7 - x))
        else
          Inc(total, StrToInt(Copy(cnpj, x, 1)) * (15 - x));
      end;
      dg2:=11 - (total mod 11);
      if dg2 > 9 then
          dg2:=0;
      if (dg1 = StrToInt(Copy(cnpj, 13, 1))) and (dg2 = StrToInt(Copy(cnpj, 14, 1))) then
          ret:=True
      else
          ret:=False;
    except
      ret:=False;
    end;
    case AnsiIndexStr(cnpj,['00000000000000','11111111111111','22222222222222','33333333333333','44444444444444','55555555555555','66666666666666','77777777777777','88888888888888','99999999999999']) of
      0..9: ret:=False;
    end;
  end;
  Result := ret;
end;

class function TUtils.ValidaCPF(pValue: string): Boolean;
var
  i:integer;
  Want:char;
  Wvalid:boolean;
  Wdigit1,Wdigit2:integer;
begin
  Result := False;
  if pValue='' then
    Exit;
  Wdigit1:=0;
  Wdigit2:=0;
  Want:=pValue[1];
  Delete(pValue,ansipos('.',pValue),1);
  Delete(pValue,ansipos('.',pValue),1);
  Delete(pValue,ansipos('-',pValue),1);
  for i:=1 to length(pValue) do
    if pValue[i] <> Want then
    begin
      Wvalid:=True;
      break
    end;
  if not Wvalid then
    begin
      Result:=False;
      exit;
    end;
  for i:=1 to 9 do
    wdigit1:=Wdigit1+(strtoint(pValue[10-i])*(I+1));
  Wdigit1:=((11 - (Wdigit1 mod 11))mod 11) mod 10;
  if IntToStr(Wdigit1) <> pValue[10] then
  begin
    Result:=False;
    exit;
  end;
  for i:=1 to 10 do
    wdigit2:=Wdigit2+(strtoint(pValue[11-i])*(I+1));
  Wdigit2:= ((11 - (Wdigit2 mod 11))mod 11) mod 10;
  if IntToStr(Wdigit2) <> pValue[11] then
  begin
    Result:=False;
    exit;
  end;
  Result:=True;
end;

class function TUtils.CEPExiste(CEP: string; out Lista: TList): Boolean;
const
  sqlPesquisaCEP = 'select distinct '+
                   '  geral_fonte_pagadora.cep, '+
                   '  geral_fonte_pagadora.logradouro, '+
                   '  geral_fonte_pagadora.complemento, '+
                   '  geral_fonte_pagadora.bairro, '+
                   '  geral_fonte_pagadora.localidade, '+
                   '  geral_fonte_pagadora.uf '+
                   'from '+
                   '  geral_fonte_pagadora '+
                   'where '+
                   '  geral_fonte_pagadora.cep = :cep';
var
  Registro: TStringList;
begin
  with TQUERY.Create(sqlPesquisaCEP) do
    try
      qy.ParamByName('cep').AsString := CEP;
      qy.Open;
      Result := (qy.RecordCount > 0);
      if Result then
      begin
        Registro := TStringList.Create;
        Registro.Values['cep'] := qy.FieldByName('cep').AsString;
        Registro.Values['logradouro'] := qy.FieldByName('logradouro').AsString;
        Registro.Values['complemento'] := qy.FieldByName('complemento').AsString;
        Registro.Values['bairro'] := qy.FieldByName('bairro').AsString;
        Registro.Values['localidade'] := qy.FieldByName('localidade').AsString;
        Registro.Values['uf'] := qy.FieldByName('uf').AsString;

        Lista.Add(Registro);
      end;
    finally
      Free;
    end;
end;

class function TUtils.EnderecoExiste(UF, Localidade, Logradouro: string; out ListaRetorno: TList): Boolean;
const
  sqlPesquisaCEP = 'select distinct '+
                   '  geral_fonte_pagadora.cep, '+
                   '  geral_fonte_pagadora.logradouro, '+
                   '  geral_fonte_pagadora.complemento, '+
                   '  geral_fonte_pagadora.bairro, '+
                   '  geral_fonte_pagadora.localidade, '+
                   '  geral_fonte_pagadora.uf '+
                   'from '+
                   '  geral_fonte_pagadora '+
                   'where '+
                   '  geral_fonte_pagadora.uf = :uf and '+
                   '  lower(geral_fonte_pagadora.localidade) like lower(:localidade) or lower(geral_fonte_pagadora.logradouro) like lower(:logradouro)';
var
  Registro: TStringList;
begin
  with TQUERY.Create(sqlPesquisaCEP) do
    try
      qy.ParamByName('uf').AsString := UF;
      qy.ParamByName('localidade').AsString := '%'+Localidade+'%';
      qy.ParamByName('logradouro').AsString := '%'+Logradouro+'%';
      qy.Open;
      Result := (qy.RecordCount > 0);
      if Result then
      begin
        while not qy.Eof do
        begin
          Registro := TStringList.Create;
          Registro.Values['cep'] := qy.FieldByName('cep').AsString;
          Registro.Values['logradouro'] := qy.FieldByName('logradouro').AsString;
          Registro.Values['complemento'] := qy.FieldByName('complemento').AsString;
          Registro.Values['bairro'] := qy.FieldByName('bairro').AsString;
          Registro.Values['localidade'] := qy.FieldByName('localidade').AsString;
          Registro.Values['uf'] := qy.FieldByName('uf').AsString;

          ListaRetorno.Add(Registro);

          qy.Next;
        end;
      end;
    finally
      Free;
    end;
end;

end.
