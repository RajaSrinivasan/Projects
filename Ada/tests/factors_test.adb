with Ada.Command_Line ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.long_long_integer_text_io; use Ada.long_long_integer_text_io ;
with Ada.Containers ;
with long_long_numbers ;

procedure factors_test is
   num : long_long_integer ;
   use Ada.Containers ;
begin
   
    if ada.command_line.argument_count < 1
    then
       return ;
    end if ;
    
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
       Long_Long_Numbers.Show("Prime factors" , Fac ) ;
    end ;
	
    declare
       fac : long_long_numbers.Vector_Pkg.Vector ;
       curs : long_long_numbers.Vector_Pkg.Cursor ;
    begin
       fac := long_long_numbers.Factors( num ) ;
       Long_Long_Numbers.Show("All factors",Fac) ;
    end ;	

    declare
       fac : long_long_numbers.Vector_Pkg.Vector ;
       curs : long_long_numbers.Vector_Pkg.Cursor ;
    begin
       fac := long_long_numbers.Divisors( num ) ;
       Long_Long_Numbers.Show("All divisors" , Fac ) ;
    end ;	
    
    declare
       fac : long_long_numbers.Digits_Pkg.Vector ;
       curs : long_long_numbers.Digits_Pkg.Cursor ;
    begin
       fac := long_long_numbers.Digitize( num ) ;
       Long_Long_Numbers.Show("All digits" , Fac ) ;
    end ;	
	
    if Long_Long_Numbers.IsPerfect( Num )
    then
       Put_Line("Is Perfect");
    else
       Put_Line("Is not perfect") ;
    end if ;

    if Long_Long_Numbers.IsTrimorphic( Num )
    then
       Put_Line("Is Trimorphic") ;
    else
       Put_Line("Is not Trimorphic") ;
    end if ;

end factors_test ;
