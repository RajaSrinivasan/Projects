package stm32f4.buttons is

   type pin_no is range 0..15 ;
   type Button_Type is
      record
         base : stm32f4.word ;
         pin : pin_no ;
      end record ;

   function create (portbase : stm32f4.word ;
                    pin : pin_no ) return Button_Type ;
   function pushed( button : button_type ) return boolean ;

end stm32f4.buttons ;
