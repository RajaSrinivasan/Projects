with Ada.Text_Io; use Ada.Text_Io ;

with Queue ;
with Qclient_cli ;                            -- [cli/$_cli]
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
   Put_Line("Bye");
end qclient ;                         -- [clitest/$]
