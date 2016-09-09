with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Interfaces.C;          use Interfaces.C;

with GNAT.Sockets ;
with GNAT.Time_Stamp ;

with SQLite ;

with Queue ;
with Qmanager_Cli ;

package body Qmanager_Pkg is

   Mysocket : GNAT.Sockets.Socket_Type ;
   ServerPort : Integer := 10756 ;

   Databaseconnected : Boolean := False ;
   Mydb : SQLite.Data_Base ;
   Databasename : String := "qmanager.db" ;

   procedure SetPort( PortNo : Integer ) is
   begin
      ServerPort := PortNo ;
   end SetPort ;

   procedure ConnectToDatabase is
      Stmt : String :=
        "CREATE TABLE jobs " &
        "(" &
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " &
        "client TEXT, " &
        "added DATE, " &
        "cmdfile TEXT" &
        ") ;" ;
   begin
      MyDb := SQLite.Open( Databasename ) ;
      if not SQLite.Table_Exists( MyDb , "jobs" )
      then
         SQLite.Exec( MyDb , Stmt ) ;
      end if ;
      Databaseconnected := True ;
   end ConnectToDatabase ;

   procedure List_All_Jobs_Service( Client : GNAT.Sockets.Socket_Type;
                                    Msg : Queue.Message_Type ) is
      Reply : Queue.Message_Type ;
   begin
      Reply := Queue.Create( Queue.RESPONSE , Queue.LIST_ALL_JOBS ) ;
      Queue.Send( client , Reply ) ;
   end List_All_Jobs_Service ;

   procedure Submit_Job_Service( Client : GNAT.Sockets.Socket_Type;
                                 Msg : Queue.Message_Type ) is
      Reply : Queue.Message_Type ;
      Filepath : String := Queue.GetFile( Msg , "commandfile" ) ;
      procedure SaveJob is
         Insertstmt : SQLite.Statement := SQLite.Prepare(MyDb, "INSERT INTO jobs (cmdfile,added) VALUES (?,?) ;" ) ;
         Datetime : aliased String := GNAT.Time_Stamp.Current_Time  ;
         FindStmt : SQLite.Statement :=  SQLite.Prepare(MyDb, "SELECT id FROM jobs WHERE added='" & Datetime & "';" ) ;
         NewId : Int ;
      begin
         SQLite.Bind( InsertStmt , 1 , Filepath ) ;
         SQLite.Bind( InsertStmt , 2 , Datetime ) ;
         SQLite.Step( InsertStmt ) ;
         Put_Line("Data Inserted at" & Datetime );
         SQLite.Step( FindStmt ) ;
         NewId := SQLite.Column( FindStmt , 1 ) ;
         Put_Line("New Id " & Integer'Image(Integer(NewId)));
      exception
         when others =>
            Put_Line("Exception in SaveJob");
      end SaveJob ;
   begin
      if Qmanager_Cli.Verbose
      then
         Put("Command file :");
         Put_Line( Filepath ) ;
      end if ;

      if not DatabaseConnected
      then
         if Qmanager_Cli.Verbose
         then
            Put_Line("Connecting to Database");
         end if ;
         ConnectToDatabase ;
      end if ;
      if Qmanager_Cli.Verbose
      then
         Put(Filepath) ;
         Put(" Queued from ");
         Put_Line( GNAT.Sockets.Image( GNAT.Sockets.Get_Peer_Name( Client ) ) );
      end if ;
      SaveJob ;
      Reply := Queue.Create( Queue.RESPONSE , Queue.SUBMIT_JOB ) ;
      Queue.Send( client , Reply ) ;
   end Submit_Job_Service ;

   procedure ProvideService (Client : GNAT.Sockets.Socket_Type) Is
      Msg : Queue.Message_Type ;
      Reply : Queue.Message_Type ;
      Svc : Queue.Services_Type ;
   begin
      loop
         Queue.Receive( client , Msg ) ;
         Svc := Queue.Get( Msg ) ;
         case Svc is
            when Queue.LIST_ALL_JOBS =>
              List_All_Jobs_Service( Client, Msg ) ;
              return ;
            when Queue.SUBMIT_JOB =>
              Submit_Job_Service( Client, Msg ) ;
              return ;
            when others =>
               null ;
         end case ;
         Reply := Queue.Create( Queue.DONT_UNDERSTAND , Svc ) ;
         Queue.Send( client , Reply ) ;
      end loop ;
   exception
      when others => null ;
   end ProvideService ;

   procedure StartService is
      myaddr   : GNAT.Sockets.Sock_Addr_Type;
   begin
      GNAT.Sockets.Create_Socket( Mysocket ) ;
      myaddr.Addr := GNAT.Sockets.Any_Inet_Addr;
      myaddr.Port := GNAT.Sockets.Port_Type (ServerPort);
      GNAT.Sockets.Bind_Socket (mysocket, myaddr) ;
      loop
         GNAT.Sockets.Listen_Socket (mysocket);
         declare
            use GNAT.Sockets;
            clientsocket : GNAT.Sockets.Socket_Type;
            clientaddr   : GNAT.Sockets.Sock_Addr_Type;
            accstatus    : GNAT.Sockets.Selector_Status;
         begin
            GNAT.Sockets.Accept_Socket
              (mysocket,
               clientsocket,
               clientaddr,
               5.0,
               Status => accstatus);
            if accstatus = GNAT.Sockets.Completed then
               Put("Received a connection Client: ") ;
               Put( GNAT.Sockets.Image( Clientaddr ) ) ;
               New_Line ;
               ProvideService (Clientsocket) ;
               GNAT.Sockets.Close_Socket (clientsocket);
            end if;
         end;
      end loop ;
   end StartService ;

begin
   Put( "Server Host: ");
   Put( GNAT.Sockets.Host_Name ) ;
   New_Line;
end Qmanager_Pkg ;
