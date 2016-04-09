with numbers_Suite ;                       -- [template/$]
with AUnit.Test_Suites ; use AUnit.Test_Suites ;
with AUnit.Run ;
with AUnit.Reporter.Text ;

procedure numbers_Unit_Test is              -- [template/$]
    procedure Run is new AUnit.Run.Test_Runner( numbers_Suite.Suite );  -- [template/$]
    Reporter : AUnit.Reporter.Text.Text_Reporter ;
begin
    Run(Reporter);
end numbers_Unit_Test ;  -- [template/$]
