pragma Restrictions (No_Elaboration_Code);
with system ;

package stm32f4.crc is

   DR_ResetValue : constant  := 16#ffff_ffff# ;
   IDR_ResetValue : constant := 0 ;
   CR_ResetValue : constant := 0 ;

   CR_MaskReset : constant := 16#0000_0001# ;

   procedure Initialize ;
   pragma Inline(Initialize) ;

   procedure Reset ;
   function compute( from : system.address ;
                     length : integer )
                    return word ;

private
   type IDR_Type is
      record
         IDR : Bits_8 ;
      end record ;
   for IDR_Type use
      record
         IDR at 0 range 0..7 ;
      end record ;
   for IDR_Type'Size use 32 ;
   type CR_Type is
      record
         RESET : Bits_1 ;
      end record ;
   for CR_Type use
      record
         RESET at 0 range 0..0 ;
      end record ;
   for CR_Type'Size use 32 ;

   type CRC_Map_Type is
      record
         DR : Word ;
         IDR : IDR_Type ;
         CR : CR_Type ;
      end record ;

end stm32f4.crc ;
