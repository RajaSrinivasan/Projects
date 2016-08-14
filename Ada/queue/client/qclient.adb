with qclient_cli ;                            -- [cli/$_cli]
with Qclient_Pkg ;

procedure qclient is                  -- [clitest/$]
begin
   qclient_cli.ProcessCommandLine ;           -- [cli/$_cli]
   if Qclient_Cli.Verbose
   then
      Qclient_Cli.ShowCommandLineArguments ;
   end if ;
   
   Qclient_Pkg.SetServer( Qclient_Cli.ServerNodeName.all ,
			  Qclient_Cli.ServerPortNumber ) ;
   if Qclient_Cli.ListOption
   then
      Qclient_Pkg.ShowJobs ;
   end if ;
   
end qclient ;                         -- [clitest/$]
