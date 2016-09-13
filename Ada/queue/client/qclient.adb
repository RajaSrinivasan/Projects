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
   Queue.Verbose := Qclient_Cli.Verbose ;
   Qclient_Pkg.SetServer( Qclient_Cli.ServerNodeName.all ,
                          Qclient_Cli.ServerPortNumber ) ;


   if Qclient_Cli.ListOption
   then
      Qclient_Pkg.ShowJobs ;
   elsif Qclient_Cli.DeleteOption
   then
      QClient_Pkg.Delete_Job( Integer'Value(QClient_Cli.GetNextArgument) ) ;
   else
      Qclient_Pkg.Submit( Qclient_Cli.GetNextArgument , "" ) ;
   end if ;

   Put_Line("Bye");

end qclient ;                         -- [clitest/$]
