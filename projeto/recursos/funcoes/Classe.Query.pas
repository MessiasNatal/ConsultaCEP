unit Classe.Query;

interface

uses
  Data.DB, System.Variants, Vcl.Dialogs, System.Classes, System.SysUtils, FireDAC.Comp.Client, FireDAC.Stan.Param;

type
  TQUERY = class
  strict private
    FQuery: TFDQuery;
  public
    constructor Create(pSql: string = ''; pNome: string = ''; AOwner: TComponent = nil);
    destructor Destroy; override;
    property qy: TFDQuery read FQuery write FQuery;
  end;

implementation

uses
  Constantes;

{ TQUERY }

constructor TQUERY.Create(pSql: string = ''; pNome: string = ''; AOwner: TComponent = nil);
begin
  FQuery := TFDQuery.Create(AOwner);
  if pNome <> '' then
    FQuery.Name := pNome;
  FQuery.Connection := Sessao.Conexao.Connection;
  FQuery.CachedUpdates := True;
  FQuery.SQL.Clear;
  if pSql <> '' then
    FQuery.SQL.Add(pSql);
end;

destructor TQUERY.Destroy;
begin
  FreeAndNil(FQuery);
  inherited;
end;

end.
