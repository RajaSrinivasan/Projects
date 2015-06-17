with system ;
with ada.real_time; use ada.real_time ;

with registers ;
with STM32F4.gpio ;

package body stm32f4.buttons is

   Debounce_Time : constant Time_Span := Milliseconds (500);
   function create (portbase : stm32f4.word ;
                    pin : pin_no ) return Button_Type is
      btn : Button_Type ;
      pinint : constant integer := integer(pin) ;

      gpio : stm32f4.gpio.GPIO_Register
           with
             Volatile,
          Address => System'To_Address (portbase);
      exticr_address : system.address ;
      extiidx : integer := integer(pin mod 4) ;
   begin
      btn.base := portbase ;
      btn.pin := pin ;
            --  Enable clock for GPIO-A
      registers.RCC.AHB1ENR := registers.RCC.AHB1ENR or 16#01# ;
      --  Configure PA0
      case pin is
         when  0 ..  3 => exticr_address := registers.SYSCFG.EXTICR1'address ;
         when  4 ..  7 => exticr_address := registers.SYSCFG.EXTICR2'address ;
         when  8 .. 11 => exticr_address := registers.SYSCFG.EXTICR3'address ;
         when 12 .. 15 => exticr_address := registers.SYSCFG.EXTICR4'address ;
      end case ;
      declare
         syscfg_exticr : Bits_8x4 with Volatile , address => exticr_address ;
         pragma import(Ada,syscfg_exticr);
      begin
         case portbase is
              when stm32f4.GPIOA_Base => syscfg_exticr( extiidx ) := 0 ;
              when stm32f4.GPIOB_Base => syscfg_exticr( extiidx ) := 1 ;
              when stm32f4.GPIOC_Base => syscfg_exticr( extiidx ) := 2 ;
              when stm32f4.GPIOD_Base => syscfg_exticr( extiidx ) := 3 ;
              when others => raise Program_Error ;
         end case ;
      end ;

      GPIO.MODER (pinint) := STM32F4.GPIO.Mode_IN;
      GPIO.PUPDR (pinint) := STM32F4.GPIO.No_Pull;

      --  Select PA for EXTI0
      registers.SYSCFG.EXTICR1 (0) := 0;

      return btn ;
   end create ;

   function Set( button : button_type ) return boolean is
      gpio : stm32f4.gpio.GPIO_Register
        with
          Volatile,
          Address => System'To_Address (button.base);
   begin
      return ( gpio.IDR and 16#01# ) = 1;
   end Set ;

end stm32f4.buttons ;
