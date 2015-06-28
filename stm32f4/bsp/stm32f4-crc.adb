with system.storage_elements ; use system.storage_elements ;
with registers ;

package body stm32f4.crc is

   CRCMAP : CRC_Map_Type
        with Volatile ,
        Address => System'To_Address( stm32f4.CRC_Base ) ;
   pragma Import(Ada,CRCMAP) ;

   procedure initialize is
      RCC_AHB1ENR_CRCEN : constant word := 16#0000_1000# ;
   begin
      registers.RCC.AHB1ENR := registers.RCC.AHB1ENR or RCC_AHB1ENR_CRCEN ;
   end initialize ;

   procedure Reset is
      RCC_AHB1ENR_CRCEN : constant word := 16#0000_1000# ;
      CRRESET : CR_Type ;
   begin
      CRRESET.RESET := 1 ;
      CRCMAP.CR := CRRESET ;
      registers.RCC.AHB1ENR := registers.RCC.AHB1ENR or RCC_AHB1ENR_CRCEN ;
   end Reset ;

   function Compute( from : system.address ;
                     length : integer )
                    return word is


      lengthtodo : integer := length ;
      wordptr : system.address := from ;
      lastword : word := 0 ;
      result : word ;
   begin
      -- registers.RCC.AHB1ENR := registers.RCC.AHB1ENR or RCC_AHB1ENR_CRCEN ;

      Reset ;
      while lengthtodo > 3
      loop
         declare
            nextword : word
              with address => wordptr ;
         begin
            CRCMAP.DR := nextword ;
         end ;
         lengthtodo := lengthtodo - 4 ;
         wordptr := wordptr + 4 ;
      end loop ;
      while lengthtodo > 0
      loop
         declare
            nextbyte : byte
              with address => wordptr ;
         begin
            lastword := shift_left(lastword,8) or word(nextbyte) ;
         end ;
         lengthtodo := lengthtodo - 1 ;
         wordptr := wordptr + 1 ;
      end loop ;
        CRCMAP.DR := lastword ;
      result := CRCMAP.DR ;

      return result ;
   end compute ;

end stm32f4.crc ;
