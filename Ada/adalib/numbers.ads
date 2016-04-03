with Ada.Containers.Vectors ;
generic
   type number_type is range <> ;
package numbers is

    type decimal_digits_type is range 0..9 ;
    type octal_digits_type is range 0..7 ;
    type hexadecimal_digits_type is range 0..15 ;

    package vector_pkg is new ada.Containers.Vectors (
        Index_Type => Natural ,
        Element_Type => number_type
    ) ;

    package Digits_Pkg is new Ada.Containers.Vectors(
						     Index_Type => Natural ,
						     Element_Type => Decimal_Digits_Type);
    

    function IsPrime( Number : Number_Type ) return Boolean ;
    -- Prime_Factors
    --      - prime numbers which are factors of the given number
    --        (no duplicates of the factors)
    function Prime_Factors( number : number_type )
			  return vector_pkg.Vector ;
    -- Factors
    --     - factorize the number with primes. (product of all these = number)
    function Factors( Number : Number_Type )
		    return Vector_Pkg.Vector ;
    -- Divisors
    --     - divisors of the number.
    function Divisors( Number : Number_Type )
		    return Vector_Pkg.Vector ;
    
    function Digitize( Number : Number_Type )
		   return Digits_Pkg.Vector ;
    
end numbers ;
