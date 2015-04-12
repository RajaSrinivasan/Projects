with system ;
with system.storage_elements ;
with interfaces ;

package crc16 is

   type block_type is array (integer range <>) of interfaces.unsigned_8 ;

   pragma pack(block_type) ;

   procedure Update( Oldvalue : Interfaces.Unsigned_16 ;
                     Blockptr : System.Address ;
                     Blocklen : Integer ;
                     Newvalue : out Interfaces.Unsigned_16 ) ;
   function Compute( Blockptr : System.address ;
                     blocklen : integer )
                    return Interfaces.Unsigned_16 ;

   procedure Update( Oldvalue : Interfaces.Unsigned_16 ;
                     Block : Block_Type ;
                     Newvalue : out Interfaces.Unsigned_16) ;
   procedure Update( crcvalue : in out interfaces.unsigned_16 ;
                     block : system.Storage_Elements.Storage_Array ) ;
   procedure Selftest ;
end crc16 ;
