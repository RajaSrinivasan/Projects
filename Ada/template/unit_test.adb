with template_Suite ;                       -- [template/$]
with AUnit.Test_Suites ; use AUnit.Test_Suites ;
with AUnit.Run ;
with AUnit.Reporter.Text ;

procedure template_Unit_Test is              -- [template/$]
    procedure Run is new AUnit.Run.Test_Runner( template_Suite.Suite );  -- [template/$]
    Reporter : AUnit.Reporter.Text.Text_Reporter ;
begin
    Run(Reporter);
end template_Unit_Test ;  -- [template/$]
