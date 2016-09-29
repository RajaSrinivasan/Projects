with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Ada.Exceptions ;

with Interfaces.C;          use Interfaces.C;

with GNAT.Sockets ;
with GNAT.Time_Stamp ;
with GNAT.Source_Info ;

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
      listjobsstmt : SQLite.Statement := SQLite.Prepare( MyDb ,
                                                         "SELECT * FROM jobs ; " ) ;
   begin
      Reply := Queue.Create( Queue.RESPONSE , Queue.LIST_ALL_JOBS ) ;
      while SQLite.Step( listjobsstmt )
      loop
         for col in 1..SQLite.Column_Count( listjobsstmt )
         loop
            Put( SQLite.Column_Name( listjobsstmt , col ) );
            Put( " => " ) ;
            Put( SQLite.Column( listjobsstmt , col ) ) ;
         end loop ;
         New_Line ;
      end loop ;
      Queue.Send( client , Reply ) ;
   end List_All_Jobs_Service ;

   procedure Submit_Job_Service( Client : GNAT.Sockets.Socket_Type;
                                 Msg : Queue.Message_Type ) is
      Reply : Queue.Message_Type ;
      Filepath : String := Queue.GetFile( Msg , "commandfile" ) ;
      NewId : Int := -1 ;
      procedure SaveJob is
         Insertstmt : SQLite.Statement := SQLite.Prepare(MyDb, "INSERT INTO jobs (cmdfile,added,client) VALUES (?,?,?) ;" ) ;
         Datetime : aliased String := GNAT.Time_Stamp.Current_Time  ;
         FindStmt : SQLite.Statement :=  SQLite.Prepare(MyDb, "SELECT id FROM jobs WHERE added='" & Datetime & "';" ) ;
         client : aliased String := Queue.Get( Msg , "hostname" ) ;
      begin
         SQLite.Bind( InsertStmt , 1 , Filepath ) ;
         SQLite.Bind( InsertStmt , 2 , Datetime ) ;
         SQLite.Bind( InsertStmt , 3 , client ) ;
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

      if Qmanager_Cli.Verbose
      then
         Put(Filepath) ;
         Put(" Queued from ");
         Put_Line( Queue.Get( Msg , "hostname") );
      end if ;
      SaveJob ;
      Reply := Queue.Create( Queue.RESPONSE , Queue.SUBMIT_JOB ) ;
      Queue.Set_Argument( Reply , "newjob" , Integer( NewId ) ) ;
      Queue.Send( client , Reply ) ;
   end Submit_Job_Service ;
   procedure Delete_Job_Service( Client : GNAT.Sockets.Socket_Type;
                                 Msg : Queue.Message_Type ) is
      Reply : Queue.Message_Type ;
      jobid : Integer := Queue.Get( Msg , "jobid" ) ;
      --DelStmt : SQLite.Statement := SQLite.Prepare(MyDb,"DELETE FROM jobs WHERE id = " & Integer'Image(jobid) & " ;") ;
      DelStmt : SQLite.Statement ;
   begin
      Put_Line("Delete Job Service");
      Reply := Queue.Create( Queue.RESPONSE , Queue.DELETE_JOB ) ;      Reply := Queue.Create( Queue.RESPONSE , Queue.DELETE_JOB ) ;
      DelStmt := SQLite.Prepare(MyDb,"DELETE FROM jobs WHERE id = " & Integer'Image(jobid) & " ;") ;
      Reply := Queue.Create( Queue.RESPONSE , Queue.DELETE_JOB ) ;
      if QManager_Cli.Verbose
      then
         Put("Delete Job ");
         Put( jobid ) ;
         New_line ;
      end if ;
      SQLite.Step( DelStmt ) ;
      Queue.Set_Argument( Reply , "R1/R2/R3" , "Region 1 , Region 2 , Region 3") ;
      Queue.Set_Argument( Reply , "status" , "done" ) ;
      Queue.Send( client , Reply ) ;
   exception
      when error : others =>
         Put("Exception : "); Put( Ada.Exceptions.Exception_Name( error ) ) ;
         New_Line ;
         Put( GNAT.Source_Info.Enclosing_Entity ) ;
         Put( " : " ) ;
         Put( GNAT.Source_Info.Source_Location ) ;
         New_Line ;
         Queue.Set_Argument( Reply , "status" , "exception" ) ;
         Queue.Send( client , Reply ) ;
   end Delete_Job_Service ;

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
            when Queue.DELETE_JOB =>
               Delete_Job_Service( Client , Msg ) ;
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
   ConnectToDatabase ;
end Qmanager_Pkg ;
