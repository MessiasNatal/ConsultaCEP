unit Classe.Ini;

interface

uses
  IniFiles, System.SysUtils, Classe.Utils;

type
  TIni = class
  public
    class function GetPathDataBase: string;
    class function GetPortaDataBase: Integer;
    class function GetLibDataBase: string;
    class function GetHostDataBase: string;
  end;

const
  Conexao = 'conexao';
  Styles = 'styles';
var
  Ini: TIniFile;

implementation

{ TIni }

class function TIni.GetPathDataBase: string;
begin
  Result := Ini.ReadString(Conexao,'database','');
end;

class function TIni.GetPortaDataBase: Integer;
begin
  Result := Ini.ReadInteger(Conexao,'porta',3050);
end;

class function TIni.GetHostDataBase: string;
begin
  Result := Ini.ReadString(Conexao,'hostname','localhost');
end;

class function TIni.GetLibDataBase: string;
begin
  Result := Ini.ReadString(Conexao,'lib','');
end;

initialization
  Ini := TIniFile.Create(TUtils.getCaminhoParametro);

finalization
  FreeAndNil(Ini);

end.
