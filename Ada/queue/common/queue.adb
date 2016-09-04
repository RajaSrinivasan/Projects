with Ada.Directories ;
with Ada.Streams ;
with Ada.Streams.Stream_IO;
with Ada.Text_Io; use Ada.Text_Io ;

with System.Storage_Elements ;

with GNATCOLL.JSON; use GNATCOLL.JSON ;
with GNAT.Directory_Operations ; use GNAT.Directory_Operations ;

with Text ;

package body Queue is

   function Create( Packet : Packet_Type ;
                    Service : Services_Type ) return Message_Type is
      Msg : Message_Type ;
   begin
      Msg.Contents := GNATCOLL.JSON.Create_Object ;
      Set_Field( Msg.Contents , "version" , Create(Version) ) ;
      Set_Field( Msg.Contents , "packettype" , Create( Integer(Packet_Type'Pos(Packet)))) ;
      Set_Field( Msg.Contents , "service" , Create( Integer(Services_Type'Pos(Service)))) ;
      Set_Field( Msg.Contents , "command" , Create( Services_Type'Image( Service ) ) ) ;
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

   procedure Add_File( Msg : in out Message_Type ;
                       Name : String ;
                       Path : String ) is
      use Ada.Streams ;
      file   : Ada.Streams.Stream_IO.File_Type;
      stream : Ada.Streams.Stream_IO.Stream_Access;
      Filesize : Integer ;
   begin
      Filesize := Integer(Ada.Directories.Size( Path )) ;
      declare
         use System.Storage_Elements ;
         Basename : String := Gnat.Directory_Operations.Base_Name( Path ) ;
         Filedatabuffer : Ada.Streams.Stream_Element_Array( 1..Stream_Element_Offset(FileSize) ) ;
         Filedatabytes : System.Storage_Elements.Storage_Array( 1..Storage_Offset(FileSize) ) ;
         for Filedatabytes'Address use Filedatabuffer'Address ;
      begin
         Ada.Streams.Stream_IO.Open
           (file,
            Ada.Streams.Stream_IO.In_File,
            Path );
         stream := Ada.Streams.Stream_IO.Stream (file);
         Stream.Read( Stream_Element_Array(Filedatabuffer) , Stream_Element_Offset(FileSize) ) ;
         declare
            Filedatabase64 : String := Text.Base64_Encode( Filedatabytes ) ;
            Packeddata : Gnatcoll.Json.JSON_VALUE ;
         begin
            Packeddata := Gnatcoll.Json.Create_Object ;
            Set_Field( Packeddata , "basename" , Basename ) ;
            Set_Field( Packeddata , "contents" , Filedatabase64 ) ;
            Set_Field( Msg.Contents , Name , Packeddata ) ;
         end ;
         Ada.Streams.Stream_IO.Close(File) ;
      end ;
   end Add_File ;

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
