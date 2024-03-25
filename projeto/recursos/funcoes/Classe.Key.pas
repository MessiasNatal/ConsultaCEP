unit Classe.Key;

interface

uses
  SysUtils, Classe.Query, Classe.Utils, Vcl.Dialogs, Data.DB;

type
  TKey = class
    class function getKey(pTabela : string; pNome_Campo : string = ''; pIdEmpresa : Integer = 0):Integer;
  end;

implementation

class function TKey.getKey(pTabela : string; pNome_Campo : string = ''; pIdEmpresa : Integer = 0): Integer;
var
  TabelaCampo : string;
begin
  pTabela := UpperCase(pTabela);
  if pTabela = '' then
  begin
    TUtils.MsgInfo('Paramêtro de geração de KEY não informado.');
    Abort;
  end;
  with TQUERY.Create do
    try
      if pNome_Campo = '' then
        pNome_Campo := 'ID';

      TabelaCampo := Concat(pTabela,'_','[',pNome_Campo,']');

      if pIdEmpresa > 0 then
        TabelaCampo := Concat(pTabela,'_','[',pNome_Campo,']_Empresa_' + pIdEmpresa.ToString);

      TabelaCampo := UpperCase(TabelaCampo);

      repeat
        qy.Close;
        qy.SQL.Clear;
        qy.SQL.Add('select ultimo_id from keys_increment where tabela =:tabela');
        qy.ParamByName('TABELA').AsString := TabelaCampo;
        qy.Open;

        if qy.IsEmpty then
        begin
          qy.Close;
          qy.SQL.Clear;

          if pIdEmpresa > 0 then
            qy.SQL.Add('select (max('+ pNome_Campo +'))as ultimo_id from ' + pTabela + ' where id_empresa = ' + pIdEmpresa.ToString)
          else
            qy.SQL.Add('select (max('+ pNome_Campo +'))as ultimo_id from ' + pTabela);

          qy.Open;
          begin
            if qy.IsEmpty then
              Result := 1
            else
              Result := qy.FieldByName('ultimo_id').AsInteger + 1;
          end;
          begin
            qy.Close;
            qy.SQL.Clear;
            qy.SQL.Add('insert into keys_increment (ultimo_id,tabela) values (:ultimo_id,:tabela)');
            qy.ParamByName('ultimo_id').AsInteger:=  Result;
            qy.ParamByName('tabela').AsString := TabelaCampo;
            qy.ExecSQL;
          end;
        end
        else
        begin
          Result := qy.FieldByName('ultimo_id').AsInteger + 1;
          qy.Close;
          qy.SQL.Clear;
          qy.SQL.Add('update keys_increment set ultimo_id =:ultimo_id WHERE tabela=:tabela ');
          qy.ParamByName('ultimo_id').AsInteger:=  Result;
          qy.ParamByName('tabela').AsString := TabelaCampo;
          qy.ExecSQL;
        end;

        qy.Close;
        qy.SQL.Clear;

        if pIdEmpresa > 0 then
          qy.SQL.Add('select '+ pNome_Campo +' from '+ pTabela +'  where id_empresa =  ' + pIdEmpresa.ToString + ' and ' + pNome_Campo +'= '+ Result.ToString +' ')
        else
          qy.SQL.Add('select '+ pNome_Campo +' from '+ pTabela +'  where '+ pNome_Campo +'= '+ Result.ToString +' ');

        qy.Open;
      until (qy.IsEmpty);

    finally
      Free;
    end;
end;

end.

