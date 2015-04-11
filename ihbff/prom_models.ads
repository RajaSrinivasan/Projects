with Interfaces ;
with Prom ;

package Prom_Models is
    type context_type is
      record
         called : integer := 0 ;
      end record ;
   package ByteProm_pkg is new prom( interfaces.unsigned_8 , context_type ) ;
   package WordProm_pkg is new prom( interfaces.unsigned_16 , context_type ) ;
end Prom_Models ;
