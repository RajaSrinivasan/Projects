with AUnit ; use AUnit ;
with AUnit.Test_Cases ; use AUnit.Test_Cases ;
package integrate_Tests is            -- [template/$]
    type integrate_Test is new Test_Cases.Test_Case with null record ;   -- [template/$]
    procedure Register_Tests( T : in out integrate_Test );               -- [template/$]
    function Name( T : integrate_Test ) return Message_String ;          -- [template/$]
    procedure Test_integrate( T : in out Test_Cases.Test_Case'Class ) ; -- [template/$]


end integrate_Tests ;                 -- [template/$]
