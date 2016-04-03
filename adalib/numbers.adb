with ada.numerics.long_elementary_functions ;

package body numbers is
    package body digits_pkg is
        function digitize( number : number_type ) return digits_vector_pkg.vector is
            vec : digits_vector_pkg.vector ;
        begin
            return vec ;
        end digitize ;
    end digits_pkg ;

    function factorize( number : number_type )
             return vector_pkg.Vector is
        vec : vector_pkg.Vector ;
        number_float : long_float := long_float(number) ;
        sqrt_float : long_float := ada.numerics.long_elementary_functions.sqrt(number_float) ;
        number_sqrt : number_type := number_type(sqrt_float) ;
    begin
        vec.append(1);
        for n in 2..number_sqrt
        loop
            if (number rem n) = 0
            then
               vec.append(n) ;
            end if ;
        end loop ;
        return vec ;
    end factorize ;
end numbers ;
