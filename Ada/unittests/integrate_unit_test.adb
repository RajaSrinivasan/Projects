with integrate_Suite ;                       -- [template/$]
with AUnit.Test_Suites ; use AUnit.Test_Suites ;
with AUnit.Run ;
with AUnit.Reporter.Text ;

procedure integrate_Unit_Test is              -- [template/$]
    procedure Run is new AUnit.Run.Test_Runner( integrate_Suite.Suite );  -- [template/$]
    Reporter : AUnit.Reporter.Text.Text_Reporter ;
begin
    Run(Reporter);
end integrate_Unit_Test ;  -- [template/$]
