with Ada.Command_Line ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.long_long_integer_text_io; use Ada.long_long_integer_text_io ;

with long_long_numbers ;
procedure factors_test is
    num : long_long_integer ;
begin
    if ada.command_line.argument_count > 0
    then
        num := long_long_integer'value( ada.command_line.argument(1)) ;
        declare
           fac : long_long_numbers.Vector_Pkg.Vector ;
           curs : long_long_numbers.Vector_Pkg.Cursor ;
        begin
           fac := long_long_numbers.factorize( num ) ;
           put("Factors of ");
           put( num ) ;
           new_line ;
           for fn in 1..long_long_numbers.Vector_Pkg.length(fac)
           loop
              curs := long_long_numbers.Vector_Pkg.To_Cursor( fac , integer(fn) ) ;
              put( long_long_numbers.Vector_Pkg.Element( curs ) ) ;
              new_line ;
           end loop ;
        end ;
    end if ;
end factors_test ;
