with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with GNAT.Sockets ;

with Queue ;

with Qmanager_Cli ;

package body Qmanager_Pkg is
   Mysocket : GNAT.Sockets.Socket_Type ;
   ServerPort : Integer := 10756 ;
   procedure SetPort( PortNo : Integer ) is
   begin
      ServerPort := PortNo ;
   end SetPort ;

   procedure ProvideService (Client : GNAT.Sockets.Socket_Type) Is
      Msg : Queue.Message_Type ;
      Reply : Queue.Message_Type ;
   begin
      loop
         Queue.Receive( client , Msg ) ;
         Reply := Queue.Create( Queue.RESPONSE , Queue.LIST_ALL_JOBS ) ;
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
