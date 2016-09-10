with Queue ;

with Qmanager_cli ;                            -- [cli/$_cli]
with Qmanager_Pkg ;

procedure qmanager is                  -- [clitest/$]
begin
   qmanager_cli.ProcessCommandLine ;           -- [cli/$_cli]
   if Qmanager_Cli.Verbose
   then
      Qmanager_Cli.ShowCommandLineArguments ;
   end if ;
--   Queue.Verbose := Qmanager_Cli.Verbose ;
   Qmanager_Pkg.SetPort( Qmanager_Cli.ServerPortNo ) ;

   Qmanager_Pkg.StartService ;
end qmanager ;                         -- [clitest/$]
