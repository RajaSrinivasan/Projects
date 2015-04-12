with Interfaces ;

with ihbr ;
with Prom ;

package Prom_Models is
    type context_type is
      record
         called : integer := 0 ;
         blocksize : integer := 16 ;
         nextbyte : integer := 0 ;
      end record ;
   package ByteProm_pkg is new prom( interfaces.unsigned_8 , context_type ) ;
   procedure Converter (module  : ByteProm_Pkg.module_type;
                        binrec  : out Ihbr.Ihbr_Binary_Record_Type;
                        context : in out context_type);

   package WordProm_pkg is new prom( interfaces.unsigned_16 , context_type ) ;
end Prom_Models ;
