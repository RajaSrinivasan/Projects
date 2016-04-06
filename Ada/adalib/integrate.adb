package body Integrate is
   
   function Newton_Coates_3( X1, X2 : Real_T ;
			     Integrand : Integrand_Type ) return Real_T is
      C  : Real_T := -1.0/90.0 ;
      W1 : Real_T := 1.0/3.0 ;
      W2 : Real_T := 4.0/3.0 ;
      W3 : Real_T := 1.0/3.0 ;
      MIDX : Real_T := ( X1 + X2 ) / 2.0 ;
      Y1, Y2, MIDY : Real_T ;
      H : Real_T := MIDX - X1 ;
   begin
      Y1 := Integrand( X1 ) ;
      Y2 := Integrand( X2 ) ;
      MIDY := Integrand( MIDX ) ;
      
      return H * ( W1 * Y1 + W2 * MIDY + W3 * Y2 ) ;
      
   end Newton_Coates_3 ;
      
   function Newton_Coates_4( X1, X2 : Real_T ;
			     Integrand : Integrand_Type ) return Real_T is
      C  : Real_T := -3.0/80.0 ;
      W1 : Real_T := 3.0/8.0 ;
      W2 : Real_T := 9.0/8.0 ;
      W3 : Real_T := 9.0/8.0 ;
      W4 : Real_T := 3.0/8.0 ;
      H  : Real_T := ( X2 - X1 ) / 3.0 ;
   begin
      return H * (W1 * Integrand(X1) + W2 * Integrand(X1+H) + W3 * Integrand(X1+H*2.0) + W4 * Integrand(X2) ) ;
   end Newton_Coates_4 ;
   
   function Newton_Coates_5( X1, X2 : Real_T ;
			     Integrand : Integrand_Type ) return Real_T is
      C  : Real_T := -8.0/945.0 ;
      W1 : Real_T := 14.0/45.0 ;
      W2 : Real_T := 64.0/45.0 ;
      W3 : Real_T := 24.0/45.0 ;
      W4 : Real_T := 64.0/45.0 ;
      W5 : Real_T := 14.0/45.0 ;
      H  : Real_T := ( X2 - X1 ) / 4.0 ;
   begin
      return H * (W1 * Integrand(X1) +
		    W2 * Integrand(X1+H) +
		    W3 * Integrand(X1+H*2.0) +
		    W4 * Integrand(X1+H*3.0) +
		    W5 * Integrand(X2)) ;
   end Newton_Coates_5 ;
   
end Integrate ;
