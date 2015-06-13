--
-- Example program morse
--
with System;
with Ada.Real_Time; use Ada.Real_Time;

with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
with stm32f4.leds ;
with discovery ;
with morsecode.led ;

procedure Morse is
   pragma Priority (System.Priority'First);
   Period     : constant Time_Span := Milliseconds (2000);
   Next_Start : Time := Clock;
begin
   discovery.initialize ;
   loop

      STM32F4.leds.Off(discovery.virtual_led1) ;
      STM32F4.leds.On(discovery.virtual_led2) ;

      morsecode.led.show(discovery.green,"SOS");
      Next_Start := Next_Start + Period;
      delay until Next_Start;

      morsecode.led.show(discovery.red,"HELP");
      Next_Start := Next_Start + Period;
      delay until Next_Start;

      STM32F4.leds.Toggle(discovery.virtual_led1) ;
      STM32F4.leds.Toggle(discovery.virtual_led2) ;

      morsecode.led.show(discovery.orange,"8689");
      Next_Start := Next_Start + Period;
      delay until Next_Start;

      morsecode.led.show(discovery.blue,"1056");
      Next_Start := Next_Start + Period;
      delay until Next_Start;

   end loop ;
end Morse ;
