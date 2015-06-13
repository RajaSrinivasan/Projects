with system ;
with ada.real_time; use ada.real_time ;
with ada.interrupts.names ;

with registers ;
with STM32F4.gpio ;

package body stm32f4.buttons is

   protected Button is
      pragma Interrupt_Priority;
      function state( pin : pin_no ) return boolean ;
   private
      pin_pushed : array (pin_no'range) of boolean := (others => false) ;
      procedure Interrupt_Handler;
      pragma Attach_Handler
         (Interrupt_Handler,
          Ada.Interrupts.Names.EXTI0_Interrupt);
      Last_Time : ada.real_time.Time := ada.real_time.Clock ;
   end Button;
   Debounce_Time : constant Time_Span := Milliseconds (500);
   protected body Button is

      function state( pin : pin_no ) return boolean is
      begin
         return pin_pushed( pin ) ;
      end state ;
      procedure Interrupt_Handler is
         Now : constant Time := Clock;
         actpin : pin_no := pin_no'first ;
      begin
         for pin in pin_no'range
         loop
            if EXTI.PR(pin)
            then
               EXTI.PR(pin) := 1 ;
               actpin := pin ;
               exit ;
            end if ;
         end loop ;
         --  Debouncing
         if Now - Last_Time >= Debounce_Time then
            Last_Time := Now;
            -- toggle pin state
            pin_pushed( actpin ) := not pin_pushed( actpin ) ;
         end if;
      end Interrupt_Handler;
   end Button;

   function create (portbase : stm32f4.word ;
                    pin : pin_no ) return Button_Type is
      btn : Button_Type ;
      pinint : constant integer := integer(pin) ;

      gpio : stm32f4.gpio.GPIO_Register
           with
             Volatile,
          Address => System'To_Address (portbase);
      exticr_address : system.address ;
      extiidx : integer := pin_no mod 4 ;
   begin
      btn.base := portbase ;
      btn.pin := pin ;
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

      --  Interrupt on rising edge and falling edge
      registers.EXTI.FTSR (pinint) := 1;
      registers.EXTI.RTSR (pinint) := 1;
      registers.EXTI.IMR (pinint) := 1;

      return btn ;
   end create ;

   function pushed( button : button_type ) return boolean is
   begin
      return state( button.pin ) ;
   end pushed ;

end stm32f4.buttons ;
