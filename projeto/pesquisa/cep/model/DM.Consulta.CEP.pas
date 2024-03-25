unit DM.Consulta.CEP;

interface

uses
  System.SysUtils, System.Classes, DM.Padrao, Vcl.AppEvnts, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TDMConsultaCEP = class(TDMPadrao)
    memPadrao: TFDMemTable;
    memPadraoCEP: TStringField;
    memPadraoLOGRADOURO: TStringField;
    memPadraoCOMPLEMENTO: TStringField;
    memPadraoBAIRRO: TStringField;
    memPadraoLOCALIDADE: TStringField;
    memPadraoUF: TStringField;
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
