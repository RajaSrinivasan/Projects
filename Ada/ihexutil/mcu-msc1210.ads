package mcu.msc1210 is

   type msc1210_flash_Type is new mcu.flash_type with
      record
         rom : bits8_memory_block_ptr_type ;
      end record ;

   type msc1210_Type is new mcu.Controller_Type with
      record
         flash : msc1210_flash_type ;
      end record ;

   mcutype_msc1210 : string := "msc1210" ;
   function Create( name : string ) return msc1210_type ;

   overriding
   procedure GenerateHexFile( controller : msc1210_type ;
                              hexfilename : string ;
                              blocklen : integer ) ;
   procedure Set( controller : msc1210_type ;
                 romaddress : Unsigned_32 ;
                 value : Unsigned_32 ) ;
   function Get( controller : msc1210_type ;
                 romaddress : Unsigned_32 )
                return Unsigned_32 ;
   procedure Set( controller : msc1210_type ;
                  rom : ihbr.ihbr_Binary_Record_Type ) ;
   procedure Get( controller : msc1210_type ;
                  romaddress : in out Unsigned_32 ;
                  blocklen : integer ;
                  end_of_memory : out boolean ;
                  rec : out ihbr.Ihbr_Binary_Record_Type );


   function CRC( controller : msc1210_type )
                     return Unsigned_16 ;

   procedure StoreCRC( controller : in out msc1210_type ;
                       crcaddress : Unsigned_32 ) ;

   procedure Show( controller : msc1210_type ) ;

end mcu.msc1210 ;
