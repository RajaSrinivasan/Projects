with integrate_tests ;               -- [template/$]

package body integrate_suite is       -- [template/$]
    t : aliased integrate_Tests.integrate_Test ;    -- [template/$]
    function suite return Access_Test_Suite is
        Ret : constant Access_Test_Suite := new Test_Suite;
    begin
        integrate_Tests.Register_Tests( T );        -- [template/$]
        Ret.Add_Test( T'access );
        return Ret ;
    end suite ;
end integrate_suite ;                               -- [template/$]
