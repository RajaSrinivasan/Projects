
package body Morsecode is
 
   ---------------
   function Translate( C : Character ) return Letter_Representation is
   begin
      case c is
         when 'A' => return (Dot , Dash) ;
         when 'B' => return ( Dash , Dot , Dot , Dot )  ;
         when 'C' => return (Dash , Dot , Dash , Dot ) ;
         when 'D' => return ( Dash , Dot , Dot ) ;   
         when 'E' => return Letter_Representation'(1 => Dot) ;
         when 'F' => return (Dot , Dot , Dash , Dot )  ;
         when 'G' => return (Dash, Dash, Dot ) ;
         When 'H' => return ( Dot , Dot , Dot ,  Dot ) ;
         When 'I' => return (Dot , Dot )  ;
         When 'J' => return (Dot , Dash, Dash, Dash )  ;
         when 'K' => return (Dash , Dot , Dash );
         When 'L' => return ( Dot , Dash , Dot , Dot )  ;
         When 'M' => return (Dash, Dash );
         When 'N' => return (Dash , Dot );   
         When 'O' => return (Dash , Dash , Dash ) ;
         When 'P' => return (Dot , Dash , Dash , Dot )  ;
         When 'Q' => return (Dash , Dash , Dot , Dash ) ;
         When 'R' => return (Dot , Dash , Dot )  ;
         When 'S' => return (Dot , Dot , Dot ) ;   
         When 'T' => return  Letter_Representation'(1 => Dash)  ;
         When 'U' => return (Dot , Dot , Dash )  ;
         When 'V' => return (Dot , Dot , Dot , Dash )  ;
         When 'W' => return (Dot, Dash , Dash ) ;
         When 'X' => return (Dash , Dot , Dot , Dash )  ;
         When 'Y' => return (Dash , Dot , Dash , Dash )  ;
         When 'Z' => return (Dash , Dash , Dot , Dot ) ;
                
         When '0' => return ( Dash , Dash , Dash , Dash , Dash )  ;   
         When '1' => return ( Dot , Dash , Dash , Dash , Dash )  ;   
         When '2' => return (Dot , Dot , Dash , Dash , Dash  ) ;
         When '3' => return (Dot , Dot , Dot , Dash , Dash  ) ;
         When '4' => return ( Dot , Dot , Dot , Dot , Dash  ) ;
         When '5' => return ( Dot , Dot , Dot , Dot , Dot  ) ;
         When '6' => return ( Dash , Dot , Dot , Dot , Dot  ) ;   
         When '7' => return (Dash , Dash , Dot , Dot , Dot ) ;
         When '8' => return ( Dash , Dash , Dash , Dot , Dot  ) ;   
         When '9' => return ( Dash , Dash , Dash , Dash , Dot  ) ;   
         when others => raise Unsupported_Character ;
      end case ;
   end Translate ;
                
end Morsecode ;
