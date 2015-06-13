
package stm32f4.leds is

   type pin_no is range 0..15 ;
   type LED_Type is
      record
         base : stm32f4.word ;
         pin : pin_no ;
         off : boolean := true ;
      end record ;

   function create (portbase : stm32f4.word ;
                    pin : pin_no ) return LED_Type ;

   procedure  On( this : in out LED_Type ) with inline ;
   procedure Off( this : in out LED_Type ) with inline ;
   procedure Toggle( this : in out LED_Type ) with inline ;

end stm32f4.leds ;
