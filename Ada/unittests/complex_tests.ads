with AUnit ; use AUnit ;
with AUnit.Test_Cases ; use AUnit.Test_Cases ;
package Complex_Tests is
    type Complex_Test is new Test_Cases.Test_Case with null record ;
    procedure Register_Tests( T : in out Complex_Test );
    function Name( T : Complex_Test ) return Message_String ;
    procedure Test_Abs( T : in out Test_Cases.Test_Case'Class ) ;
    procedure Test_Argument( T : in out Test_Cases.Test_Case'Class ) ;
    procedure Test_Polar( T : in out Test_Cases.Test_Case'Class ) ;

end Complex_Tests ;
