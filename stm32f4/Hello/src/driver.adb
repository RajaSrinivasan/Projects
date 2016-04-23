
with LEDs;          use LEDs;
with Button;        use Button;
with Ada.Real_Time; use Ada.Real_Time;

package body Driver is

   type Index is mod 4;

   Pattern : constant array (Index) of User_LED := (Orange, Red, Blue, Green);
   --  The LEDs are not physically laid out "consecutively" in such a way that
   --  we can simply go in enumeral order to get circular rotation. Thus we
   --  define this mapping, using a consecutive index to get the physical LED
   --  blinking order desired.

   task body Controller is
      Period     : constant Time_Span := Milliseconds (1000);  -- arbitrary
      Next_Start : Time := Clock;
      Next_LED   : Index := 0;
      current_pattern : Button.Counter_Type := Button.Current_Counter ;
      procedure Original_Pattern (clockwise : boolean) is
      begin
         LEDS.Off (Pattern (Next_LED));
         if clockwise then
            Next_LED := Next_LED - 1;
         else
            Next_LED := Next_LED + 1;
         end if;
         LEDS.On( Pattern(Next_LED) ) ;
      end Original_Pattern ;

      procedure Modified_Pattern is
      begin
         LEDS.All_Off ;
         Next_LED := Next_LED + 1 ;
         LEDS.On (Pattern (Next_LED));
         LEDS.On (Pattern (Next_LED+2));
      end Modified_Pattern ;

   begin
      loop
         if current_pattern /= Button.Current_Counter
         then
            current_pattern := Button.Current_Counter ;
            LEDS.All_Off ;
         else
            case current_pattern is
            when 0 => Original_Pattern ( true );
            when 1 => Modified_Pattern ;
            when 2 => Original_Pattern ( false ) ;
            when others => LEDS.All_On ;
            end case ;
         end if ;
         Next_Start := Next_Start + Period;
         delay until Next_Start;
      end loop;
   end Controller;

end Driver;
