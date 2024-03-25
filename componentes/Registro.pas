unit Registro;

interface

procedure register;

implementation

uses
  System.Classes, Consulta.CEP;

procedure register;
begin
  RegisterComponents('Components by Messias',[TConsultaCEP]);
end;

end.
