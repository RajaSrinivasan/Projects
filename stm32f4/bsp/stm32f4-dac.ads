pragma Restrictions (No_Elaboration_Code);

package STM32F4.DAC is

private
   type DAC_CR_Type is
      record
         EN1 : Bits_1 ;            -- DAC channel1 enable
         BOFF1 : Bits_1 ;          -- DAC channel1 output buffer disable
         TEN1 : Bits_1 ;           -- DAC channel1 trigger enable
         TSEL1 : Bits_3 ;          -- DAC channel1 trigger selection
         WAVE1 : Bits_2 ;          -- DAC channel1 noise/triangle wave generation enable
         MAMP1 : Bits_4 ;          -- DAC channel1 mask/amplitude selector
         DMAEN1 : Bits_1 ;         -- DAC channel1 DMA enable
         DMAUDRIE1 : Bits_1 ;      -- DAC channel1 DMA Underrun Interrupt enable
         Reserved_1 : Bits_2 ;

         EN2 : Bits_1 ;            -- DAC channel2 enable
         BOFF2 : Bits_1 ;          -- DAC channel2 output buffer disable
         TEN2 : Bits_1 ;           -- DAC channel2 trigger enable
         TSEL2 : Bits_3 ;          -- DAC channel2 trigger selection
         WAVE2 : Bits_2 ;          -- DAC channel2 noise/triangle wave generation enable
         MAMP2 : Bits_4 ;          -- DAC channel2 mask/amplitude selector
         DMAEN2 : Bits_1 ;         -- DAC channel2 DMA enable
         DMAUDRIE2 : Bits_1 ;      -- DAC channel2 DMA Underrun Interrupt enable
         Reserved_2 : Bits_2 ;

      end record ;
   for DAC_CR_Type'Size use Word'Size ;
   for DAC_CR_Type use
      record
         EN1 at 0 range 0..0 ;
         BOFF1 at 0 range 1..1 ;
         TEN1 at 0 range 2..2 ;
         TSEL1 at 0 range 3..5 ;
         WAVE1 at 0 range 6..7 ;
         MAMP1 at 0 range 8..11 ;
         DMAEN1 at 0 range 12..12 ;
         DMAUDRIE1 at 0 range 13..13 ;
         Reserved_1 at 0 range 14..15 ;
         EN2 at 2 range 0..0 ;
         BOFF2 at 2 range 1..1 ;
         TEN2 at 2 range 2..2 ;
         TSEL2 at 2 range 3..5 ;
         WAVE2 at 2 range 6..7 ;
         MAMP2 at 2 range 8..11 ;
         DMAEN2 at 2 range 12..12 ;
         DMAUDRIE2 at 2 range 13..13 ;
         Reserved_2 at 2 range 14..15 ;
      end record ;

   type DAC_SWTRIGR_Type is
      record
         SWTRIG1 : Bits_1 ;              -- DAC channel1 software trigger
         SWTRIG2 : Bits_1 ;              -- DAC channel2 software trigger
         Reserved_1 : Bits_14 ;
         Reserved_2 : Half_Word ;
      end record ;
   for DAC_SWTRIGR_Type'Size use Word'Size ;
   for DAC_SWTRIGR_Type use
      record
         SWTRIG1 at 0 range 0..0 ;
         SWTRIG2 at 0 range 1..1 ;
         Reserved_1 at 0 range 2..15 ;
         Reserved_2 at 2 range 0..15 ;
      end record ;

   type DAC_SR_Type is
      record
         Reserved_1 : Bits_12 ;
         DMAUDR1 : Bits_1 ;
         Reserved_2 : Bits_2 ;
         Reserved_3 : Bits_12 ;
         DMAUDR2 : Bits_1 ;
         Reserved_4 : Bits_2 ;
      end record ;
   for DAC_SR_Type'Size use Word'Size ;
   for DAC_SR_Type use
      record
         Reserved_1 at 0 range 0..12 ;
         DMAUDR1 at 0 range 13..13 ;
         Reserved_2 at 0 range 14..15 ;
         Reserved_3 at 0 range 16..28 ;
         DMAUDR2 at 0 range 29..29 ;
         Reserved_4 at 0 range 30..31 ;
      end record ;

   type DAC_Map_Type is
      record
         CR : Word ;                   -- DAC control register
         SWTRIGR : Word ;              -- DAC software trigger register
         DHR12R1 : Word ;              -- channel1 12-bit right-aligned data holding register
         DHR12L1 : Word ;              -- channel1 12-bit left aligned data holding register
         DHR8R1 : Word ;               -- channel1 8-bit right aligned data holding register
         DHR12R2 : Word ;              -- channel2 12-bit right aligned data holding register
         DHR12L2 : Word ;              -- channel2 12-bit left aligned data holding register
         DHR8R2 : Word ;               -- channel2 8-bit right-aligned data holding register
         DHR12RD : Word ;              -- Dual DAC 12-bit right-aligned data holding register
         DHR12LD : Word ;              -- DUAL DAC 12-bit left aligned data holding register
         DHR8RD : Word ;               -- DUAL DAC 8-bit right aligned data holding register
         DOR1 : Word ;                 -- channel1 data output register
         DOR2 : Word ;                 -- channel2 data output register
         SR : Word ;                   -- DAC status register
      end record ;

end STM32F4.DAC ;
