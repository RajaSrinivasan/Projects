with complex_tests ;

package body complex_suite is
    t : aliased Complex_Tests.Complex_Test ;
    function suite return Access_Test_Suite is
        Ret : constant Access_Test_Suite := new Test_Suite;

    begin
        Complex_Tests.Register_Tests( T );
        Ret.Add_Test( T'access );
        return Ret ;
    end suite ;
end complex_suite ;
