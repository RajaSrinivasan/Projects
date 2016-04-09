
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Complex_Text_Io ;
with Ada.Float_Text_Io ; use Ada.Float_Text_Io ;
with long_long_numbers ;

with AUnit.Assertions ; use AUnit.Assertions ;

package body numbers_tests is  -- [template/$]

    procedure Register_Tests( T : in out numbers_Test ) is   -- [template/$]
       use AUnit.Test_Cases.Registration ;
    begin
        Register_Routine( T , Test_Prime_numbers'access , "Prime numbers Test") ; -- [template/$]
    end Register_Tests ;

    function Name( T : numbers_Test ) return Message_String is   -- [template/$]
    begin
        return Format("numbers Tests") ; -- [template/$]
    end Name ;

    procedure Test_Prime_numbers( T : in out Test_Cases.Test_Case'Class ) is  -- [template/$]
    begin
        AUnit.Assertions.Assert(
               long_long_numbers.IsPrime(7) , "IsPrime 7") ;
        AUnit.Assertions.Assert(
                      not long_long_numbers.IsPrime(1056) , "IsPrime 7") ;
    end test_Prime_numbers ;      -- [template/$]

end numbers_tests ;    -- [template/$]
