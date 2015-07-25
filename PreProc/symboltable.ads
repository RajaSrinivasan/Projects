with ada.strings.unbounded ; use ada.strings.unbounded ;
with ada.strings.unbounded.Less_Case_Insensitive ;

with Ada.Containers.Indefinite_Ordered_Maps ;

package SymbolTable is
   package stb_pkg is
      new Ada.Containers.Indefinite_Ordered_Maps(
                                                                  unbounded_string , unbounded_string ,
                                                                  "<" => ada.strings.unbounded.Less_Case_Insensitive ,
                                                 "=" => ada.strings.unbounded."=" ) ;

    procedure Print( Symbol : Stb_Pkg.Cursor ) ;
    procedure Print( Symboltable : Stb_Pkg.Map ) ;

end SymbolTable ;
