generic
   type Real_T is digits <> ;
package Integrate is
   type Integrand_Type is access
     function ( X : Real_T ) return Real_T ;
   function Newton_Coates_3( X1, X2 : Real_T ;
		      Integrand : Integrand_Type ) return Real_T ;
   function Newton_Coates_4( X1, X2 : Real_T ;
		      Integrand : Integrand_Type ) return Real_T ;
   function Newton_Coates_5( X1, X2 : Real_T ;
		      Integrand : Integrand_Type ) return Real_T ;
   
   function Simpsons( X1, X2 : Real_T ;
		      Integrand : Integrand_Type ) return Real_T 
     renames Newton_Coates_3 ;
   
end Integrate ;
