with Interfaces; use Interfaces ;

with Ada.Containers.Vectors ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;

with ihbr ;

package mcu is

   type address_type is range 0..Unsigned_16'Last-1 ;

   type bits8_memory_block_type is array (integer range <>) of unsigned_8 ;
   type bits8_memory_block_ptr_type is access all bits8_memory_block_type ;

   type bits16_memory_block_type is array (integer range <>) of unsigned_16 ;
   type bits16_memory_block_ptr_type is access all bits16_memory_block_type ;

   type flash_type is tagged
      record
         name : unbounded_string ;
         start : Interfaces.Unsigned_32 ;
         length : Interfaces.Unsigned_16 ;
      end record ;

   type flash_ptr_type is access all flash_type'class ;

   type sectors_ptr_type is array (integer range <>) of flash_ptr_type ;

   function InSector( sector : flash_ptr_type ;
                      address : unsigned_32 ) return boolean ;

   function Insector( sectors : sectors_ptr_type ;
                      address : unsigned_32 ) return integer ;

   type controller_type is abstract tagged
      record
         typename : unbounded_string ;
         name : Unbounded_String ;
      end record ;

   function Create( name : string ;
                    mcutype : string ) return Controller_Type'Class ;

   function Create( name : unbounded_string ;
                    mcutype : unbounded_string ) return Controller_Type'Class ;

   procedure Initialize( controller : in out Controller_TYpe'Class ;
                         name : string ) ;
   function WordLength( controller : Controller_Type )
              return Integer ;

   procedure Set( controller : Controller_Type ;
                 romaddress : Unsigned_32 ;
                 value : Unsigned_32 ) is abstract ;
   function Get( controller : Controller_Type ;
                 romaddress : Unsigned_32 )
                return Unsigned_32 is abstract ;

   procedure Set( controller : Controller_Type ;
                  rom : ihbr.ihbr_Binary_Record_Type ) is abstract ;
   function Get( controller : Controller_Type ;
                 romaddress : Unsigned_32 ;
                blocklen : integer )
                return ihbr.ihbr_Binary_Record_Type is abstract ;

   procedure Show( controller : Controller_Type ) is abstract ;
   procedure Show( controller : access Controller_Type'Class ) ;

end mcu ;
