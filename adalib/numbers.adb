with ada.numerics.long_elementary_functions ; use Ada.Numerics.Long_Elementary_Functions ;
with Ada.Text_Io; use Ada.Text_Io ;

package body numbers is
   
   package Sorting_Pkg is new Vector_Pkg.Generic_Sorting ;
   package Digits_Text_Io is new Ada.Text_Io.Integer_Io( Decimal_Digits_Type ) ;
   use Digits_Text_Io;
   package Number_Text_Io is new Ada.Text_Io.Integer_Io( Number_Type ) ;
   use Number_Text_Io ;
    procedure Show( Context : String ; Vec : Vector_Pkg.Vector ) is
       use type Ada.Containers.Count_Type ;
    begin
       Put(Context) ;
       Put( " : " );
       for D in 0..Vector_Pkg.Length(Vec)-1
       loop
	  Put(Vector_Pkg.Element(Vec,Integer(D)));
	  Put( " " ) ;
       end loop ;
       New_Line ;
    end Show ;
   
    procedure Show( Context : String ; Vec : Digits_Pkg.Vector ) is
       use type Ada.Containers.Count_Type ;
    begin
       Put(Context) ;
       Put( " : " );
       for D in 0..Digits_Pkg.Length(Vec)-1
       loop
	  Put(Digits_Pkg.Element(Vec,Integer(D)));
	  Put( " " ) ;
       end loop ;
       New_Line ;
    end Show ;

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
       Vec.Append(1) ;
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
       Vec.Append( Number ) ;
       Sorting_Pkg.Sort( Vec ) ;
       return Vec ;
    end Divisors ;
    
    function digitize( number : number_type ) return digits_pkg.vector is
       vec : digits_pkg.vector ;
       Digitmax : Number_Type := Number_Type( Decimal_Digits_Type'Last + 1 );
       Numbernow : Number_Type := Number ;
       Nextdigit : Decimal_Digits_Type ;
    begin
       while Numbernow > 0
       loop
	  Nextdigit := Decimal_Digits_Type(Numbernow rem Digitmax) ;
	  Digits_Pkg.Prepend( Vec , Nextdigit ) ;
	  Numbernow := Numbernow / Digitmax ;
       end loop ;
       return vec ;
    end digitize ;
    
    function IsPerfect( Number : Number_Type ) return Boolean is
       Vec : Vector_Pkg.Vector ;
       Facsum : Number_Type := 0 ;
    begin
       Vec := Divisors( Number ) ;
       for Fac in 1..Vector_Pkg.Length(Vec)
       loop
	  Facsum := Facsum + Vector_Pkg.Element( Vec, Integer(Fac)-1 );
       end loop ;
       
       if Facsum = 2 * Number
       then
	  return True ;
       else
	  return False ;
       end if ;
    end IsPerfect ;
    
    function IsTrimorphic( Number : Number_Type ) return Boolean is
       Numdigits : Digits_Pkg.Vector ;
       Numcubedigits : Digits_Pkg.Vector ;
       Numcubed : Number_Type := Number ** 3 ;
       Lennumdigits, Lennumcubedigits : Integer ;
    begin
       Numdigits := Digitize( Number ) ;
       Numcubedigits := Digitize( Numcubed ) ;
       Lennumdigits := Integer(Digits_Pkg.Length(Numdigits)) ;
       Lennumcubedigits := Integer(Digits_Pkg.Length( Numcubedigits )) ;
       Show( "Digits of number   " , Numdigits ) ;
       Show( "Digits of number**3" , Numcubedigits ) ;
       for Idx in 0..Lennumdigits-1
       loop
	  if Digits_Pkg.Element( Numdigits , Idx ) /=
	    Digits_Pkg.Element( Numcubedigits , Lennumcubedigits - lennumdigits + Idx )
	  then
	     return False;
	  end if ;
       end loop ;
       return True ;
    end IsTrimorphic ;
    
end numbers ;
