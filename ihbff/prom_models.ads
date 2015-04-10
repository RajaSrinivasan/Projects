with interfaces ;
with prom ;

package prom_models is
    type context_type is
      record
         called : integer := 0 ;
      end record ;
   package byte_prom_pkg is new prom( interfaces.unsigned_8 , context_type ) ;
   package word_prom_pkg is new prom( interfaces.unsigned_16 , context_type ) ;
end prom_models ;
