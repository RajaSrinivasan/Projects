package mcu.tms320 is

   type sector_type is new mcu.flash_Type with
      record
         ram : bits16_memory_block_ptr_type ;
      end record ;
   type sector_ptr_type is access all sector_type ;

   type f2810_Type is new mcu.Controller_Type with
      record
         sectors : sectors_ptr_type(1..5) ;
      end record ;

   mcutype_f2810 : string := "f2810" ;
   function Create( name : string ) return f2810_type ;

   procedure Set( controller : f2810_type ;
                 ramaddress : Unsigned_32 ;
                 value : Unsigned_32 ) ;
   function Get( controller : f2810_Type ;
                 ramaddress : Unsigned_32 )
                return Unsigned_32 ;
   procedure Show( controller : f2810_type ) ;

end mcu.tms320 ;
