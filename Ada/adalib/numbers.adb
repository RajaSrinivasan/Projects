with ada.numerics.long_elementary_functions ; use Ada.Numerics.Long_Elementary_Functions ;

package body numbers is
   package Sorting_Pkg is new Vector_Pkg.Generic_Sorting ;
   
    package body digits_pkg is
        function digitize( number : number_type ) return digits_vector_pkg.vector is
            vec : digits_vector_pkg.vector ;
        begin
            return vec ;
        end digitize ;
    end digits_pkg ;
    
    
    function IsPrime( number : number_type )
		    return boolean is
       Number_Float : Long_Float := Long_Float(Number) ;
       Sqrt_Float : Long_Float := Sqrt( Number_Float ) ;
       Sqrt : Number_Type := Number_Type(Sqrt_Float) ;
    begin
       if Number < 2
       then
	  return False ;
       elsif Number = 2
       then
	  return True ;
       end if ;
	  
       for N in 2..Sqrt
       loop
	  if Number rem N = 0
	  then
	     return False ;
	  end if ;
       end loop ;       
       return True ;
    end IsPrime ;
           
    function Prime_Factors( number : number_type )
             return vector_pkg.Vector is
        vec : vector_pkg.Vector ;
	Number_Float : Long_Float := Long_Float(Number) ;
	Sqrt_Float : Long_Float := Sqrt( Number_Float ) ;
	Sqrt : Number_Type := Number_Type(Sqrt_Float) ;
	Numfac : Number_Type ;
    begin
        for n in 2..Number/2
        loop
	   if not Vector_Pkg.Contains( Vec , N )
	   then
	      if IsPrime(N)
	      then
		 if (number rem n) = 0
		 then
		    Vec.Append(N) ;
		    Numfac := Number / N ;
		    if Numfac > N
		      and then IsPrime( Numfac )
		    then
		       Vec.Append(Numfac) ;
		    end if ;
		 end if ;
	      end if ;
	   end if ;
        end loop ;
	Sorting_Pkg.Sort( Vec ) ;
        return vec ;
    end Prime_Factors ;
    
    function Factors( Number : Number_Type )
		    return Vector_Pkg.Vector is
       vec : vector_pkg.Vector ;
       Number_Float : Long_Float := Long_Float(Number) ;
       Sqrt_Float : Long_Float := Sqrt( Number_Float ) ;
       Sqrt : Number_Type := Number_Type(Sqrt_Float) ;
       Numfac : Number_Type ;
       Numbernow : Number_Type := Number ;
    begin
       Vec.Append( 1 ) ;
       Numfac := 2 ;
       loop
	  if Numbernow rem Numfac = 0
	  then
	     Vec.Append( Numfac ) ;
	     Numbernow := Numbernow / Numfac ;
	     if Numbernow = 1
	     then
		exit ;	     
	     end if ;
	  else
	     Numfac := Numfac + 1 ;
	  end if ;
       end loop ;
       return Vec ;
    end Factors ;
    
    function Divisors( Number : Number_Type )
		    return Vector_Pkg.Vector is
       vec : vector_pkg.Vector ;
       Number_Float : Long_Float := Long_Float(Number) ;
       Sqrt_Float : Long_Float := Sqrt( Number_Float ) ;
       Sqrt : Number_Type := Number_Type(Sqrt_Float) ;
    begin
       Vec.Append( 1 ) ;
       for Numfac in 2 .. Sqrt 
       loop
	  if Number rem Numfac = 0
	  then
	     Vec.Append( Numfac ) ;
	     Vec.Append( Number / Numfac ) ;
	  end if ;
       end loop ;
       	Sorting_Pkg.Sort( Vec ) ;
       return Vec ;
    end Divisors ;
    
    
end numbers ;
