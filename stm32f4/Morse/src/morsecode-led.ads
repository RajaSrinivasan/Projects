with stm32f4.leds;

package morsecode.led is
   -- Gaps in milliseconds
   gapEndOfWord : natural := 5000 ;
   gapEndOfSymbol : natural := 1000 ;
   durationDot : natural := 500 ;                    -- period on and the gap
   durationDash : natural := 2000 ;                  -- period on and the gap

   procedure show( led : in out stm32f4.leds.LED_Type ;
                   this : Character ) ;
   procedure show( led : in out stm32f4.leds.LED_Type ;
                   this : string  ) ;
end morsecode.led ;
