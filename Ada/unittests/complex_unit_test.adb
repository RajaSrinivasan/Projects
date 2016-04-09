with Complex_Tests ;
with Complex_Suite ;
with AUnit.Test_Suites ; use AUnit.Test_Suites ;
with AUnit.Run ;
with AUnit.Reporter.Text ;

procedure Complex_Unit_Test is
    procedure Run is new AUnit.Run.Test_Runner( Complex_Suite.Suite );
    Reporter : AUnit.Reporter.Text.Text_Reporter ;
begin
    Run(Reporter);
end Complex_Unit_Test ;
