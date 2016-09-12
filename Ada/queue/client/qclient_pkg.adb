with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with GNAT.Sockets ;

with Queue ;
with Qclient_Cli ;

package body Qclient_Pkg is
   Mysocket : GNAT.Sockets.Socket_Type ;
   procedure SetServer( NodeName : String ;
                        ServerPort : Integer ) is
      Serversocket : GNAT.Sockets.Sock_Addr_Type ;
      Hostentry : GNAT.Sockets.Host_Entry_Type := GNAT.Sockets.Get_Host_By_Name(NodeName) ;
   begin
      Serversocket.Port := GNAT.Sockets.Port_Type( ServerPort ) ;
      if Qclient_Cli.Verbose
      then
         Put("Server ");
         Put(NodeName) ;
         Put(" Host Entries");
         New_Line ;
         for Ha in 1..GNAT.Sockets.Addresses_Length(Hostentry)
         loop
            Put( GNAT.Sockets.Image(GNAT.Sockets.Addresses(Hostentry,Ha))) ;
            New_Line ;
         end loop ;
      end if ;
      ServerSocket.Addr := GNAT.Sockets.Addresses(Hostentry,1) ;
      GNAT.Sockets.Connect_Socket( Mysocket , ServerSocket ) ;
      if Qclient_Cli.Verbose
      then
         Put("Connected to ") ;
         Put( GNAT.Sockets.Image(GNAT.Sockets.Get_Peer_Name( Mysocket ))) ;
         New_Line ;
      end if ;
   exception
      when GNAT.Sockets.Host_Error =>
         Put("Unknown Server ");
         Put_Line(NodeName) ;
      when GNAT.Sockets.Socket_Error =>
         Put("Connection refused: ");
         Put("Node = "); Put(NodeName) ;
         Put(" Port = ") ; Put(ServerPort) ;
         New_Line ;
   end SetServer ;

   procedure ShowJobs is
      Msg : Queue.Message_Type ;
      Reply : Queue.Message_Type ;
   begin
      Msg := Queue.Create( Queue.Query ,
                           Queue.LIST_ALL_JOBS ) ;
      Queue.Send( MySocket , Msg ) ;
      delay 0.2 ;
      Queue.Receive( MySocket , Reply ) ;
   end ShowJobs ;

   procedure Submit( Script : String ;
                     EnvironmentFile : String ) is
      Msg : Queue.Message_Type ;
      Reply : Queue.Message_Type ;
   begin
      Msg := Queue.Create( Queue.Query ,
                           Queue.SUBMIT_JOB ) ;
      Queue.Add_File( Msg , "commandfile"  , Script ) ;
      Queue.Send( MySocket , Msg ) ;
      delay 0.2 ;
      Queue.Receive( MySocket , Reply ) ;
      declare
         newjobid : integer := Queue.Get( Reply , "newjob" ) ;
      begin
         if newjobid > 0
         then
            Put("Submitted job #") ;
            Put(newjobid) ;
         else
            put("Failed to submit the job") ;
         end if ;
         new_line ;
      end ;
   end Submit ;
begin
   GNAT.Sockets.Create_Socket( Mysocket ) ;
   Put( "Client Host: ");
   Put( GNAT.Sockets.Host_Name ) ;
   New_Line;
end Qclient_Pkg ;
