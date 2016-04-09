with Ada.Numerics.Complex_Types ;
with Ada.Numerics.Elementary_Functions ;

with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Complex_Text_Io ;
with Ada.Float_Text_Io ; use Ada.Float_Text_Io ;

with AUnit.Assertions ; use AUnit.Assertions ;

package body complex_tests is

    procedure Register_Tests( T : in out Complex_Test ) is
       use AUnit.Test_Cases.Registration ;
    begin
        Register_Routine( T , Test_Abs'access , "Test Absolute ") ;
        Register_Routine( T , Test_Argument'access , "Test Argument");
        Register_Routine( T , Test_Polar'access , "Test Polar") ;
    end Register_Tests ;

    function Name( T : Complex_Test ) return Message_String is
    begin
        return Format("Complex Tests") ;
    end Name ;

    procedure Test_Abs( T : in out Test_Cases.Test_Case'Class ) is
        C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
                             Im => 1.0 ) ;
    begin
        AUnit.Assertions.Assert(
               Ada.Numerics.Complex_Types.Modulus(C1) =
               Ada.Numerics.Elementary_Functions.Sqrt(2.0)
             , "Absolute value of 1.0 + j");
    end Test_Abs ;

    procedure Test_Argument( T : in out Test_Cases.Test_Case'Class ) is
       C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
                                                    Im => 1.0 ) ;
    begin
        AUnit.Assertions.Assert(
           Ada.Numerics.Complex_Types.Argument(C1) =
           Ada.Numerics.Elementary_Functions.Arctan(1.0)
         , "Argument of 1.0 + j");
    end Test_Argument ;

    procedure Test_Polar( T : in out Test_Cases.Test_Case'Class ) is
       use type Ada.Numerics.Complex_Types.Complex ;
       C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
                                                    Im => 1.0 ) ;
       C2 : Ada.Numerics.Complex_Types.Complex ;
       C3 : Ada.Numerics.Complex_Types.Complex ;
       EPSILON : Float := 0.1e-5 ;
    begin
       C2 := Ada.Numerics.Complex_Types.Compose_From_Polar(
                 Ada.Numerics.Elementary_Functions.Sqrt(2.0) ,
                 Ada.Numerics.Pi / 4.0 ) ;
        C3 := C2 - C1 ;
        Put("C1 ") ;
        Ada.Complex_Text_Io.Put(C1) ;
        Put(" C2 ");
        Ada.Complex_Text_Io.Put(C2) ;
        Put(" C3 ");
        Ada.Complex_Text_Io.Put(C3) ;
        new_line ;
        AUnit.Assertions.Assert(
           Ada.Numerics.Complex_Types.Modulus(C3) < EPSILON and
           Ada.Numerics.Complex_Types.Argument(C3)  < EPSILON
         , "Polar representation of 1.0 + j");
        AUnit.Assertions.Assert(
           C1 = C2
         , "Polar representation of 1.0 + j");
    end Test_Polar ;

end complex_tests ;
