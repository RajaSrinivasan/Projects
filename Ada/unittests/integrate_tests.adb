
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Complex_Text_Io ;
with Ada.Float_Text_Io ; use Ada.Float_Text_Io ;
with Ada.Numerics.Elementary_Functions ;

with AUnit.Assertions ; use AUnit.Assertions ;
with float_integrate ;

package body integrate_tests is  -- [template/$]

    procedure Register_Tests( T : in out integrate_Test ) is   -- [template/$]
       use AUnit.Test_Cases.Registration ;
    begin
        Register_Routine( T , Test_integrate'access , "integrate Test") ; -- [template/$]
    end Register_Tests ;

    function Name( T : integrate_Test ) return Message_String is   -- [template/$]
    begin
        return Format("integrate Tests") ; -- [template/$]
    end Name ;

    function f1( t : float ) return float is
       f : float ;
    begin
        f := Ada.numerics.Elementary_Functions.cos(t) +
             Ada.numerics.Elementary_Functions.sqrt( 1.0 + T**2) *
                Ada.numerics.Elementary_Functions.sin(t) ** 3 *
                Ada.numerics.Elementary_Functions.cos(t) ** 3 ;
        return f;
    end f1 ;

    procedure Test_integrate( T : in out Test_Cases.Test_Case'Class ) is  -- [template/$]
       Y : float ;
       EPSILON : constant float := 0.1e-3 ;
    begin
       Y := float_integrate.Newton_Coates_5(
                                             - Ada.numerics.pi / 4.0 ,
                                               Ada.numerics.pi / 4.0 ,
                                               f1'access ) ;
       -- Put(Y) ;
       -- Put(Ada.Numerics.Elementary_Functions.sqrt(2.0)) ;
       -- new_line ;

       Assert( abs((Y - Ada.Numerics.Elementary_Functions.sqrt(2.0))) < EPSILON ,
                "Integral of function is sqrt(2.0)");

    end test_integrate ;      -- [template/$]

end integrate_tests ;    -- [template/$]
