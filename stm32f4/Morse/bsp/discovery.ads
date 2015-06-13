with stm32f4.leds ;


package discovery is

   green,
   orange ,
   red ,
   blue
   : stm32f4.leds.led_type ;

   -- These are not real. Just pins available as logical output pins
   -- use for diagnostics
   virtual_led1,
   virtual_led2 : stm32f4.leds.led_type ;

   procedure initialize ;

end discovery ;
