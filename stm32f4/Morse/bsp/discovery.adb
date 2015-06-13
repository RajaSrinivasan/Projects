with STM32F4 ;
with registers ;

package body discovery is
   procedure initialize is
      use stm32f4 ;
      RCC_AHB1ENR_GPIOA : constant stm32f4.Word := 16#01#; -- For the user button
      RCC_AHB1ENR_GPIOD : constant stm32f4.Word := 16#08#; -- for the 4 LEDs
   begin
      --  Enable clock for GPIO-D
      registers.RCC.AHB1ENR := registers.RCC.AHB1ENR or RCC_AHB1ENR_GPIOA or RCC_AHB1ENR_GPIOD ;

      green := stm32f4.leds.create( stm32f4.gpiod_base , 12 ) ;
      orange := stm32f4.leds.create( stm32f4.gpiod_base , 13 ) ;
      red := stm32f4.leds.create( stm32f4.gpiod_base , 14 ) ;
      blue := stm32f4.leds.create( stm32f4.gpiod_base , 15 ) ;

      virtual_led1 := stm32f4.leds.create( stm32f4.gpiod_base , 10 ) ;
      virtual_led2 := stm32f4.leds.create( stm32f4.gpiod_base , 11 ) ;

   end initialize ;
end discovery ;
