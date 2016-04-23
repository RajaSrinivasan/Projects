with Ada.Command_Line ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.long_long_integer_text_io; use Ada.long_long_integer_text_io ;
with Ada.Containers ;
with long_long_numbers ;

procedure numbers_test is
   num : long_long_integer ;
   use Ada.Containers ;
   Digs : Long_Long_Numbers.Digits_Pkg.Vector ;
begin
   
    if ada.command_line.argument_count < 1
    then
       return ;
    end if ;
    
    num := long_long_integer'value( ada.command_line.argument(1)) ;
    Digs := Long_Long_Numbers.Digitize( Num ) ;
    Long_Long_Numbers.Show("Digits of number" , Digs ) ;
    Num := Long_Long_Numbers.Value( Digs ) ;
    Put("Value is ");
    Put( Num ) ;
    New_Line ;
    
    if Long_Long_Numbers.IsKaprekar( Num )
    then
       Put("is a Kaprekar number");
    else
       Put("is not a Kaprekar number");
    end if ;
    New_Line ;
end Numbers_Test ;
