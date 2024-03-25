unit Classe.Helpers.ClassePadrao;

interface

uses
  Classe.Padrao, Classe.FontePagadora;

type
  THelperClassePadrao = class helper for TClassePadrao
    function FontePagadora: TFontePagadora;
  end;

implementation

{ THelperClassePadrao }

function THelperClassePadrao.FontePagadora: TFontePagadora;
begin
  Result := TFontePagadora(Self);
end;

end.
