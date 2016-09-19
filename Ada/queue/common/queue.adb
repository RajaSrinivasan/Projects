with Ada.Directories ;
with Ada.Streams ;
with Ada.Streams.Stream_IO;
with Ada.Text_Io; use Ada.Text_Io ;

with System.Storage_Elements ;
with GNAT.Sockets ;

with GNAT.Directory_Operations ; use GNAT.Directory_Operations ;
with GNATCOLL.JSON; use GNATCOLL.JSON ;
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
      Set_Field( Msg.Contents , "hostname" , Create( GNAT.Sockets.Host_Name ) ) ;
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
   procedure Set_Argument( Msg : in out Message_Type ;
                           Name : String ;
                           Value : Integer ) is
   begin
      Set_Field( Msg.Contents , Name , Create( Value ) ) ;
   end Set_Argument ;
   procedure Add_File( Msg : in out Message_Type ;
                       Name : String ;
                       Path : String ;
                       Base64 : Boolean := False ) is
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
         Filedatastring : String( 1..FileSize ) ;
         for Filedatastring'Address use Filedatabuffer'Address ;
      begin
         Ada.Streams.Stream_IO.Open
           (file,
            Ada.Streams.Stream_IO.In_File,
            Path );
         stream := Ada.Streams.Stream_IO.Stream (file);
         Stream.Read( Stream_Element_Array(Filedatabuffer) , Stream_Element_Offset(FileSize) ) ;
         Ada.Streams.Stream_IO.Close(File) ;
         if Base64
         then
         declare
            Filedatabase64 : String := Text.Base64_Encode( Filedatabytes ) ;
            Packeddata : Gnatcoll.Json.JSON_VALUE ;
         begin
            Packeddata := Gnatcoll.Json.Create_Object ;
            Set_Field( Packeddata , "basename" , Basename ) ;
            Set_Field( Packeddata , "base64" , "true" ) ;
            Set_Field( Packeddata , "contents" , Filedatabase64 ) ;
            Set_Field( Msg.Contents , Name , Packeddata ) ;
         end ;
         else
         declare
            Packeddata : Gnatcoll.JSON.JSON_VALUE ;
         begin
            Packeddata := Gnatcoll.Json.Create_Object ;
            Set_Field( Packeddata , "basename" , Basename ) ;
            Set_Field( Packeddata , "base64" , "false" ) ;
            Set_Field( Packeddata , "contents" , Filedatastring ) ;
            Set_Field( Msg.Contents , Name , Packeddata ) ;
         end ;
         end if ;
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

   function Get( Msg : Message_Type ) return Packet_Type is
      Pkttypeint : Integer := Gnatcoll.Json.Get(Msg.Contents,"packettype") ;
      Pkttype : Packet_Type := Packet_Type'Val(Pkttypeint) ;
   begin
      return Pkttype ;
   end Get ;

   function Get( Msg : Message_Type ) return Services_Type is
      Svctypeint : Integer := Gnatcoll.Json.Get(Msg.Contents,"service") ;
      Svc : Services_Type := Services_Type'Val(Svctypeint) ;
   begin
      return Svc ;
   end Get ;
   function Get( Msg : Message_Type ; Name : String ) return String is
   begin
      return GnatColl.JSON.Get(Msg.Contents,Name) ;
   end Get ;
   function Get( Msg : Message_Type ; Name : String ) return Integer is
      val : Integer := GNATCOLL.JSON.Get( Msg.Contents , Name ) ;
   begin
      return val ;
   end Get ;

   function GetFile( Msg : Message_Type ; Name : String ) return String is
      use System.Storage_Elements ;
      use Ada.Streams;
      packedfile : Json_Value := Gnatcoll.Json.Get(Msg.Contents, Name ) ;
      Basename : String := Gnatcoll.Json.Get(Packedfile , "basename" ) ;
      Filecontents : String := Gnatcoll.Json.Get(Packedfile , "contents" ) ;
      Base64 : String := Gnatcoll.JSON.Get(Packedfile , "base64") ;
   begin
      if Verbose
      then
         Put("File basename "); Put(Basename) ; Put( " ; Base64 = " ) ;Put_Line(Base64) ;
         Put_Line("File Contents: ") ;
         Put_Line( Filecontents ) ;
      end if ;
      if Base64 = "true"
      then
      declare
         Filedata : Storage_Array := Text.Base64_Decode( Filecontents ) ;
         Filebindata : Ada.Streams.Stream_Element_Array( 1..Stream_Element_Offset(Filedata'Length) ) ;
         for Filebindata'Address use Filedata'Address ;
         Filestr : String (1..Filedata'Length) ;
         for Filestr'Address use Filedata'Address ;
         Outfile : Ada.Streams.Stream_Io.File_Type ;
      begin
         if Verbose
         then
            Put(Filestr) ;
         end if ;
         Ada.Streams.Stream_Io.Create( Outfile , Ada.Streams.Stream_Io.Out_File , Basename ) ;
         Ada.Streams.Stream_Io.Write( Outfile , Filebindata ) ;
         Ada.Streams.Stream_Io.Close(Outfile) ;
      end ;
      else
      declare
         Filebindata : Ada.Streams.Stream_Element_Array( 1..Stream_Element_Offset(Filecontents'Length) ) ;
         for Filebindata'Address use Filecontents'Address ;
         Outfile : Ada.Streams.Stream_Io.File_Type ;
      begin
         Ada.Streams.Stream_Io.Create( Outfile , Ada.Streams.Stream_Io.Out_File , Basename ) ;
         Ada.Streams.Stream_Io.Write( Outfile , Filebindata ) ;
         Ada.Streams.Stream_Io.Close(Outfile) ;
      end ;
      end if ;
      return Basename ;
   end GetFile ;

   procedure Show( Message : Message_TYpe ) is
      Fieldvalue : Gnatcoll.Json.Json_Value ;
   begin
      Put_Line( GNATCOLL.JSON.Write( Message.Contents ) ) ;
      Fieldvalue := Gnatcoll.Json.Get( Message.Contents , "version" ) ;
      Put("Version : ");
      declare
         Vstring : String := Gnatcoll.Json.Get(Fieldvalue) ;
      begin
         Put_Line( Vstring ) ;
      end ;
      Put_Line( Packet_Type'Image(Get(Message)) );

      Put("Service : ");
      Put_Line( Services_Type'Image(Get(Message)) ) ;

      Fieldvalue := Gnatcoll.Json.Get( Message.Contents , "command" ) ;
      Put("Command : "); Put_Line( Gnatcoll.Json.Get(Fieldvalue) ) ;
   end Show ;
   procedure Set_Argument( Msg : in out Message_Type ;
                           Value : Recurrence_Type ) is
      recurrencepck : Gnatcoll.JSON.JSON_VALUE := GNATCOLL.JSON.Create_Object ;
   begin
      GNATCOLL.JSON.Set_Field( recurrencepck , "pattern" , Integer(RecurrencePattern_Type'pos(Value.pattern)) ) ;
      GNATCOLL.JSON.Set_Field( recurrencepck , "hour" , Integer( Value.hour ) ) ;
      GNATCOLL.JSON.Set_Field( recurrencepck , "minute" , Integer(Value.minute));
      GNATCOLL.JSON.Set_Field( recurrencepck , "second" , Integer(value.second)) ;
      case Value.pattern is
         when EXEC_ONCE =>
            GNATCOLL.JSON.Set_Field( recurrencepck , "execute_asap" , Value.execute_asap ) ;
         when WEEKLY =>
            for d in GNAT.Calendar.Day_name'range
            loop
               if Value.days(d)
               then
                  GNATCOLL.JSON.Set_Field( recurrencepck , GNAT.Calendar.Day_Name'Image(d) , "true" ) ;
               end if ;
            end loop ;
         when MONTHLY =>
            GNATCOLL.JSON.Set_Field( recurrencepck , "day" , Value.day ) ;
         when others =>
            null ;
      end case ;
      GNATCOLL.JSON.Set_Field( Msg.Contents , "recurrence" , recurrencepck );
   end Set_Argument ;

   function Get( Msg : Message_Type ) return Recurrence_Type is
      recurrencepck : GNATCOLL.JSON.JSON_Value := GNATCOLL.JSON.Get( Msg.Contents , "recurrence" ) ;
      recurrenceptn : Integer := GNATCOLL.JSON.Get( recurrencepck , "pattern" ) ;
      pattern : RecurrencePattern_Type := RecurrencePattern_Type'Val(recurrenceptn) ;
      hour : integer := GNATCOLL.JSON.Get( recurrencepck , "hour" ) ;
      minute : integer := GNATCOLL.JSON.Get( recurrencepck , "minute" ) ;
      second : integer := GNATCOLL.JSON.Get( recurrencepck , "second" )  ;
      procedure Set_Common_Fields ( rec : in out Recurrence_Type ) is
      begin
         rec.hour := hour ;
         rec.minute := minute ;
         rec.second := second ;
      end Set_Common_Fields ;
   begin
      case pattern is
         when EXEC_ONCE =>
            declare
               execute_asap : boolean := GNATCOLL.JSON.Get( recurrencepck , "execute_asap" ) ;
               recurrence : Recurrence_Type(EXEC_ONCE) ;
            begin
               Set_Common_Fields(recurrence) ;
               recurrence.execute_asap := execute_asap ;
               return Recurrence ;
            end ;
         when WEEKLY =>
            declare
               recurrence : Recurrence_Type(WEEKLY) ;
               dayval : boolean ;
            begin
               Set_Common_Fields(recurrence) ;
               recurrence.days := ( others => false ) ;
               for d in GNAT.Calendar.Day_Name'range
               loop
                  begin
                     dayval := GNATCOLL.JSON.Get( recurrencepck , GNAT.Calendar.Day_Name'Image(d) ) ;
                     recurrence.days(d) := true ;
                  exception
                     when others => null ;
                  end ;
               end loop ;
               return recurrence ;
            end ;
         when MONTHLY =>
            declare
               day : Integer := GNATCOLL.JSON.Get( recurrencepck , "day" ) ;
               recurrence : Recurrence_Type( MONTHLY ) ;
            begin
               Set_Common_Fields (recurrence) ;
               recurrence.day := Ada.Calendar.Day_Number( day ) ;
               return recurrence ;
            end ;
         when others =>
            declare
               recurrence : Recurrence_TYpe( pattern ) ;
            begin
               Set_Common_Fields (recurrence) ;
               return recurrence ;
            end ;
      end case ;
   end Get ;

end Queue ;
