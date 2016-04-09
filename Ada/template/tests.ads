with AUnit ; use AUnit ;
with AUnit.Test_Cases ; use AUnit.Test_Cases ;
package template_Tests is            -- [template/$]
    type template_Test is new Test_Cases.Test_Case with null record ;   -- [template/$]
    procedure Register_Tests( T : in out template_Test );               -- [template/$]
    function Name( T : template_Test ) return Message_String ;          -- [template/$]
    procedure Test_template( T : in out Test_Cases.Test_Case'Class ) ; -- [template/$]


end template_Tests ;                 -- [template/$]
