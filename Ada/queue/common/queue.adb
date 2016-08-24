with Ada.Streams ;
with Ada.Text_Io; use Ada.Text_Io ;
with GNATCOLL.JSON; use GNATCOLL.JSON ;

package body Queue is

   function Create( Packet : Packet_Type ;
                    Service : Services_Type ) return Message_Type is
      Msg : Message_Type ;
   begin
      Msg.Contents := GNATCOLL.JSON.Create_Object ;
      Set_Field( Msg.Contents , "version" , Create(Version) ) ;
      Set_Field( Msg.Contents , "packettype" , Create( Integer(Packet_Type'Pos(Packet)))) ;
      Set_Field( Msg.Contents , "service" , Create( Integer(Services_Type'Pos(Service)))) ;
      if Verbose
      then
         Put("Create: ") ;
         Show( Msg ) ;
      end if ;
      return Msg ;
   end Create ;

   procedure Set_Argument( Msg : in out Message_Type ;
                           Name : String ;
                           Value : String ) is
   begin
      Set_Field( Msg.Contents , name , Create( Value )) ;
   end Set_Argument ;

   procedure Send( Destination : GNAT.Sockets.Socket_Type ;
                   Msg : Message_Type ) is
      Channel : GNAT.Sockets.Stream_Access := GNAT.Sockets.Stream( Destination ) ;
   begin
      String'Output( Channel ,
                     Write( Msg.Contents ) ) ;
      if Verbose
      then
         Put("Send: ");
         Put(GNAT.Sockets.Image(GNAT.Sockets.Get_Peer_Name(destination))) ;
         Put("> ");
         Show(Msg) ;
      end if ;
   end Send ;

   procedure Receive( Source : GNAT.Sockets.Socket_Type ;
                      Msg : out Message_Type ) is
      Channel : GNAT.Sockets.Stream_Access := GNAT.Sockets.Stream( Source ) ;
      Strmsg : String := String'Input( Channel ) ;
   begin
      Msg.Contents := Read(Strmsg) ;
      if Verbose
      then
         Put("Receive: ");
         Put(GNAT.Sockets.Image(GNAT.Sockets.Get_Peer_Name(source))) ;
         Put("> ");
         Show(Msg) ;
      end if ;
   end Receive ;

   function Create( Key : String ) return Message_Type is
      Msg : Message_Type ;
   begin
      Msg.Contents := GNATCOLL.JSON.Create( Val => Key ) ;
      return Msg ;
   end Create ;

   procedure Show( Message : Message_TYpe ) is
   begin
      Put_Line( GNATCOLL.JSON.Write( Message.Contents ) ) ;
   end Show ;

end Queue ;
