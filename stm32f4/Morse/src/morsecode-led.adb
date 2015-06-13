with Ada.Real_Time; use Ada.Real_Time;

package body morsecode.led is

   procedure show( led : in out stm32f4.leds.LED_Type ;
                   this : Character ) is
      code : constant Letter_Representation := translate(this) ;
      now : Time := Clock ;
      dur : Time_Span ;
   begin
      for sp in code'range
      loop
         stm32f4.leds.on( led ) ;
         case code(sp) is
            when dot =>
               dur := milliseconds(durationDot) ;
               now := now + dur ;
               delay until now ;
            when dash =>
               dur := milliseconds(durationDash) ;
               now := now + dur ;
               delay until now ;
         end case ;
         stm32f4.leds.off( led ) ;
         now := now +  dur ;
         delay until now ;
      end loop ;
      now := now + milliseconds( gapEndOfSymbol ) ;
      delay until now ;
   end show ;

   procedure show( led : in out stm32f4.leds.LED_Type ;
                   this : string ) is
      now : Time := Clock ;
   begin
      for cp in this'range
      loop
         show( led , this(cp) ) ;
      end loop ;
      now := now + milliseconds( gapEndOfWord );
      delay until now ;
   end show ;

end morsecode.led ;
