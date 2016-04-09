with numbers_tests ;               -- [template/$]

package body numbers_suite is       -- [template/$]
    t : aliased numbers_Tests.numbers_Test ;    -- [template/$]
    function suite return Access_Test_Suite is
        Ret : constant Access_Test_Suite := new Test_Suite;
    begin
        numbers_Tests.Register_Tests( T );        -- [template/$]
        Ret.Add_Test( T'access );
        return Ret ;
    end suite ;
end numbers_suite ;                               -- [template/$]
