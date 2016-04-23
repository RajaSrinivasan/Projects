
--  This file provides declarations for the blue user button on the STM32F4
--  Discovery board from ST Microelectronics.

package Button is
   pragma Elaborate_Body;

   type Counter_Type is mod 5 ;
   function Current_Counter return Counter_Type ;

end Button;
