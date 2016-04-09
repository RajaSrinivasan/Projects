with AUnit ; use AUnit ;
with AUnit.Test_Cases ; use AUnit.Test_Cases ;
package numbers_Tests is            -- [template/$]
    type numbers_Test is new Test_Cases.Test_Case with null record ;   -- [template/$]
    procedure Register_Tests( T : in out numbers_Test );               -- [template/$]
    function Name( T : numbers_Test ) return Message_String ;          -- [template/$]
    procedure Test_Prime_numbers( T : in out Test_Cases.Test_Case'Class ) ; -- [template/$]


end numbers_Tests ;                 -- [template/$]
