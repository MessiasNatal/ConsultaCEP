unit Classe.Padrao.Basico;

interface

uses
  System.Classes, DM.Padrao, Data.DB;

type
  TClassePadraoBasico = class (TComponent)
  strict private
    FModel: TDMPadrao;
    FdSetPadrao: TDataSet;
  public
    constructor Create(pExterna: Boolean = False; pAOwner: TComponent = nil); virtual;
    destructor Destroy; override;

    property Model: TDMPadrao read FModel write FModel;
    property dSetPadrao: TDataSet read FdSetPadrao write FdSetPadrao;

  end;

implementation

{ TClassePadraoBasico }

constructor TClassePadraoBasico.Create(pExterna: Boolean = False; pAOwner: TComponent = nil);
begin
  inherited Create(pAOwner);
end;

destructor TClassePadraoBasico.Destroy;
begin
  inherited;
end;

end.
