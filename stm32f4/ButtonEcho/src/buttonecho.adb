with Last_Chance_Handler;  pragma Unreferenced (Last_Chance_Handler);
with STM32F4 ;
with STM32F4.leds ;
with STM32F4.buttons ;

with discovery ;


procedure buttonecho is
   button : stm32f4.buttons.Button_Type ;
begin
   discovery.initialize ;
   button := stm32f4.buttons.Create(STM32F4.GPIOA_Base , 0 ) ;
   loop
      IF STM32F4.BUTTONS.Set(button)
      then
         stm32f4.leds.On( discovery.green ) ;
         stm32f4.leds.Off( discovery.red ) ;
      else
         stm32f4.leds.Off( discovery.green ) ;
         stm32f4.leds.On( discovery.red ) ;
      end if ;
   end loop ;

end buttonecho ;
