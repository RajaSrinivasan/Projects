with ada.strings.unbounded ; use ada.strings.unbounded ;
with Ada.Containers.Indefinite_Ordered_Maps ;

package linecount_pkg is
   package summary_pkg is
       new Ada.Containers.Indefinite_Ordered_Maps(
                                        unbounded_string ,
                                        Integer) ;
   procedure Count( filename : string ) ;
   procedure ShowSummary ;
end linecount_pkg ;
