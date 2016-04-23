with STM32F4.leds;

package Morsecode.led is
   -- Gaps in milliseconds
   gapEndOfWord   : Natural := 5000;
   gapEndOfSymbol : Natural := 1000;
   durationDot    : Natural := 500;                    -- period on and the gap
   durationDash   : Natural := 2000;                  -- period on and the gap

   procedure Show (led : in out STM32F4.leds.LED_Type; this : Character);
   procedure Show (led : in out STM32F4.leds.LED_Type; this : String);
end Morsecode.led;
