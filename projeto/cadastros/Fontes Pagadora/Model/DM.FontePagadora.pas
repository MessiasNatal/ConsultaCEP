unit DM.FontePagadora;

interface

uses
  System.SysUtils, System.Classes, DM.Padrao, Data.DB, Vcl.AppEvnts, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TDMFontePagadora = class(TDMPadrao)
    qyFontePagadora: TFDQuery;
    qyFontePagadoraID_FONTE_PAGADORA: TIntegerField;
    qyFontePagadoraNOME: TStringField;
    qyFontePagadoraDATA_CADASTRO: TDateField;
    qyFontePagadoraCEP: TStringField;
    qyFontePagadoraLOGRADOURO: TStringField;
    qyFontePagadoraCOMPLEMENTO: TStringField;
    qyFontePagadoraBAIRRO: TStringField;
    qyFontePagadoraLOCALIDADE: TStringField;
    qyFontePagadoraUF: TStringField;
    qyFontePagadoraTIPO: TStringField;
    qyFontePagadoraNUMERO: TStringField;
    qyFontePagadoraDOCUMENTO: TStringField;
    qyFontePagadoraID_USUARIO_INSERCAO: TIntegerField;
    qyFontePagadoraDATA_INSERCAO: TSQLTimeStampField;
    qyFontePagadoraID_USUARIO_EDICAO: TIntegerField;
    qyFontePagadoraDATA_EDICAO: TSQLTimeStampField;
    procedure DataModuleCreate(Sender: TObject);
  end;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDMFontePagadora.DataModuleCreate(Sender: TObject);
begin
  FTabela := 'geral_fonte_pagadora';
  inherited;
end;

end.
