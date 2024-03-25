unit Classe.Helpers.Componentes;

interface

uses
  Data.DB, System.Classes, Datasnap.DBClient, Vcl.StdCtrls, Vcl.ComCtrls, Classe.Padrao, FireDAC.Comp.Client;

type
  THelperDataSet = class helper for TDataSet
    function Query: TFDQuery;
    function Cds: TClientDataSet;
    procedure SetValueReadOnly(FieldName: string; Value: Variant);
  end;

  THelperEdit = class helper for TCustomEdit
    function ToInteger: Integer;
    function ToCurrency: Currency;
  end;

  THelperEditDate = class helper for TDateTimePicker
    function ToString: string;
  end;

  THelperComponent = class helper for TComponent
    function ClassePadrao: TClassePadrao;
    function IsQueryCustom: Boolean;
    function QueryCustom: TFDQuery;
  end;

implementation

uses
  Classe.Query, System.SysUtils, Classe.Ini, Vcl.Dialogs;

{ THelperDataSet }

function THelperDataSet.Cds: TClientDataSet;
begin
  Result := TClientDataSet(Self);
end;

function THelperDataSet.Query: TFDQuery;
begin
  Result := TFDQuery(Self);
end;

procedure THelperDataSet.SetValueReadOnly(FieldName: string; Value: Variant);
begin
  if Self.FieldByName(FieldName).ReadOnly then
  begin
    Self.FieldByName(FieldName).ReadOnly := False;
    Self.FieldByName(FieldName).Value := Value;
    Self.FieldByName(FieldName).ReadOnly := True;
  end
  else
    Self.FieldByName(FieldName).Value := Value;
end;

{ THelperEdit }

function THelperEdit.ToCurrency: Currency;
begin
  Result := StrToCurr(Self.Text);
end;

function THelperEdit.ToInteger: Integer;

  function VerificarInteiro(Caracter: string): Boolean;
  var
    i:Integer;
  begin
    Result := True;
    for i := 1 to Length(Caracter) do
      if Caracter[i] in ['a'..'z','A'..'Z','"','!','@','#','$','%','¨','&','*','(',')','_','+','=','.',';',':','?','/',']','[','{','}','\','|','<','>','~','^','ª','º','´',''''] then
      begin
        Result := False;
        Break;
      end;
  end;

begin
  Self.Text := Trim(Self.Text);
  if Self.Text = '' then
    Result := 0
  else
  if not VerificarInteiro(Self.Text) then
    raise Exception.Create('Valor Incorreto.')
  else
    Result := StrToInt(Self.Text);
end;

{ THelperComponent }

function THelperComponent.ClassePadrao: TClassePadrao;
begin
  Result := TClassePadrao(Self);
end;

function THelperComponent.IsQueryCustom: Boolean;
begin
  Result := Self is TFDQuery;
end;

function THelperComponent.QueryCustom: TFDQuery;
begin
  Result := TFDQuery(Self);
end;

{ THelperEditDate }

function THelperEditDate.ToString: string;
begin
  Result := DateToStr(Self.Date);
end;

end.
