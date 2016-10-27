package mcu.tms320 is

   type sector_type is new mcu.flash_Type with
      record
         flash : bits16_memory_block_ptr_type ;
      end record ;
   type sector_ptr_type is access all sector_type ;

   type f2810_Type is new mcu.Controller_Type with
      record
         sectors : sectors_ptr_type(1..5) ;
      end record ;

   mcutype_f2810 : string := "f2810" ;
   function Create( name : string ) return f2810_type ;

   overriding
   procedure Set( controller : f2810_type ;
                 romaddress : Unsigned_32 ;
                 value : Unsigned_32 ) ;
   overriding
   function Get( controller : f2810_Type ;
                 romaddress : Unsigned_32 )
                return Unsigned_32 ;
   overriding
   function WordLength( controller : f2810_Type )
                       return Integer ;

   procedure Set( controller : f2810_Type ;
                  rom : ihbr.ihbr_Binary_Record_Type ) ;
   function Get( controller : f2810_type ;
                 romaddress : Unsigned_32 ;
                blocklen : integer )
                return ihbr.ihbr_Binary_Record_Type ;
   procedure Show( controller : f2810_type ) ;

end mcu.tms320 ;
