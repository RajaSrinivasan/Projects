with template_tests ;               -- [template/$]

package body template_suite is       -- [template/$]
    t : aliased template_Tests.template_Test ;    -- [template/$]
    function suite return Access_Test_Suite is
        Ret : constant Access_Test_Suite := new Test_Suite;
    begin
        template_Tests.Register_Tests( T );        -- [template/$]
        Ret.Add_Test( T'access );
        return Ret ;
    end suite ;
end template_suite ;                               -- [template/$]
