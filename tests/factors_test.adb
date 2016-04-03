with Ada.Command_Line ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.long_long_integer_text_io; use Ada.long_long_integer_text_io ;
with Ada.Containers ;
with long_long_numbers ;
procedure factors_test is
   num : long_long_integer ;
   use Ada.Containers ;
begin
    if ada.command_line.argument_count > 0
    then
       num := long_long_integer'value( ada.command_line.argument(1)) ;
       Put(Num) ;
       if Long_Long_Numbers.IsPrime(Num)
       then
	  Put_Line(" is a prime");
       else
	  Put_Line(" is not a prime");
       end if ;
       
        declare
           fac : long_long_numbers.Vector_Pkg.Vector ;
           curs : long_long_numbers.Vector_Pkg.Cursor ;
        begin
           fac := long_long_numbers.Prime_Factors( num ) ;
           put("Prime Factors of ");
           put( num ) ;
           new_line ;
           for fn in 0..long_long_numbers.Vector_Pkg.length(fac)-1
           loop
              curs := long_long_numbers.Vector_Pkg.To_Cursor( fac , integer(fn) ) ;
              put( long_long_numbers.Vector_Pkg.Element( curs ) ) ;
              new_line ;
           end loop ;
        end ;
	
        declare
           fac : long_long_numbers.Vector_Pkg.Vector ;
           curs : long_long_numbers.Vector_Pkg.Cursor ;
        begin
           fac := long_long_numbers.Factors( num ) ;
           put("All Factors of ");
           put( num ) ;
           new_line ;
           for fn in 0..long_long_numbers.Vector_Pkg.length(fac)-1
           loop
              curs := long_long_numbers.Vector_Pkg.To_Cursor( fac , integer(fn) ) ;
              put( long_long_numbers.Vector_Pkg.Element( curs ) ) ;
              new_line ;
           end loop ;
        end ;	

        declare
           fac : long_long_numbers.Vector_Pkg.Vector ;
           curs : long_long_numbers.Vector_Pkg.Cursor ;
        begin
           fac := long_long_numbers.Divisors( num ) ;
           put("All Divisors of ");
           put( num ) ;
           new_line ;
           for fn in 0..long_long_numbers.Vector_Pkg.length(fac)-1
           loop
              curs := long_long_numbers.Vector_Pkg.To_Cursor( fac , integer(fn) ) ;
              put( long_long_numbers.Vector_Pkg.Element( curs ) ) ;
              new_line ;
           end loop ;
        end ;	
        declare
           fac : long_long_numbers.Digits_Pkg.Vector ;
           curs : long_long_numbers.Digits_Pkg.Cursor ;
        begin
           fac := long_long_numbers.Digitize( num ) ;
           put("All Digits of ");
           put( num ) ;
           new_line ;
           for fn in 0..long_long_numbers.Digits_Pkg.length(fac)-1
           loop
              curs := long_long_numbers.Digits_Pkg.To_Cursor( fac , integer(fn) ) ;
              put( Long_Long_Integer(Long_Long_Numbers.Digits_Pkg.Element( curs )) ) ;
              new_line ;
           end loop ;
        end ;	
    end if ;
end factors_test ;
