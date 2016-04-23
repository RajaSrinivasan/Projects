with system ;
with stm32f4.GPIO ;

package body stm32f4.leds is

   function create (portbase : stm32f4.word ;
                    pin : pin_no ) return LED_Type is
      led : LED_Type ;
   begin
      led.base := portbase ;
      led.pin := pin ;
      declare
         gpio : stm32f4.gpio.GPIO_Register
           with
             Volatile,
             Address => System'To_Address (led.base);
      begin
         gpio.MODER ( integer(pin) ) := stm32f4.gpio.Mode_OUT ;
         gpio.OTYPER ( integer(pin) ) := stm32f4.gpio.Type_PP ;
         gpio.OSPEEDR ( integer(pin) ) := stm32f4.gpio.Speed_100MHz ;
         gpio.PUPDR( integer(pin) ) := stm32f4.gpio.No_Pull ;
      end ;
      return led ;
   end create ;

   procedure  On( this : in out LED_Type ) is
      gpio : stm32f4.gpio.gpio_register
        with
          Volatile,
          Address => System'To_Address (this.base);
   begin
      gpio.BSRR := shift_left( 1 , integer(this.pin) ) ;
      this.off := false ;
   end on ;

   procedure Off( this : in out LED_Type ) is
      gpio : stm32f4.gpio.gpio_register
        with
          Volatile,
          Address => System'To_Address (this.base);
   begin
      gpio.BSRR := shift_left( 1 , integer(this.pin) + 16 ) ;
      this.off := true ;
   end Off ;

   procedure Toggle( this : in out LED_Type ) is
   begin
      if this.off
      then
         On( this ) ;
      else
         Off( this ) ;
      end if ;
   end toggle ;

end stm32f4.leds ;
