
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Complex_Text_Io ;
with Ada.Float_Text_Io ; use Ada.Float_Text_Io ;

with AUnit.Assertions ; use AUnit.Assertions ;

package body template_tests is  -- [template/$]

    procedure Register_Tests( T : in out template_Test ) is   -- [template/$]
       use AUnit.Test_Cases.Registration ;
    begin
        Register_Routine( T , Test_template'access , "template Test") ; -- [template/$]
    end Register_Tests ;

    function Name( T : template_Test ) return Message_String is   -- [template/$]
    begin
        return Format("template Tests") ; -- [template/$]
    end Name ;

    procedure Test_template( T : in out Test_Cases.Test_Case'Class ) is  -- [template/$]
    begin
    null ;
    end test_template ;      -- [template/$]

end template_tests ;    -- [template/$]
