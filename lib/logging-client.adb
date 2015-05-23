with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Time_Stamp;

package body logging.client is

   Current_Destination : Destination_Access_Type;

   Current_Source            : Source_type        := Source_type'First;
   Current_Max_Message_Level : message_level_type := message_level_type'Last;

   procedure SetDestination (destination : Destination_Access_Type) is
   begin
      Current_Destination := destination;
   end SetDestination;

   procedure SetSource (name : String) is
   begin
      Current_Source := Get (name);
   end SetSource;

   procedure SetFilter (max : message_level_type) is
   begin
      Current_Max_Message_Level := max;
   end SetFilter;

   ---------
   -- log --
   ---------

   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class)
   is
      pkt : LogPacket_Type;
   begin
      if level > Current_Max_Message_Level then
         return;
      end if;
      pkt.hdr.source := Current_Source;
      pkt.level      := level;
      Ada.Strings.Fixed.Move (class, pkt.class, Ada.Strings.Right);
      pkt.MessageLen                    := message'Length;
      pkt.message (1 .. pkt.MessageLen) := message;
      SendMessage (Current_Destination.all, pkt);
   end log;

   function Create(ipaddress : string ;
                   port : integer )
                   return DatagramDestinationAccess_Type is
      newserver : DatagramDestinationAccess_Type := new DatagramDestination_Type ;
   begin
      newserver.server.Addr := gnat.sockets.Inet_Addr( ipaddress ) ;
      newserver.server.port := gnat.sockets.port_type(port) ;
      gnat.sockets.create_socket(  newserver.mysocket , mode => gnat.sockets.Socket_Datagram ) ;

      return newserver ;
   end Create ;

   procedure SendMessage
     (destination : DatagramDestination_Type;
      packet      : LogPacket_Type) is

      imgbytes : Ada.Streams.Stream_Element_Array(1..packet'Size/8) ;
      for imgbytes'address use packet'address ;
      actualsize, actualsent : ada.streams.Stream_Element_Offset ;
   begin
      actualsize := Stream_Element_Offset(imgbytes'length - MAX_MESSAGE_LENGTH + packet.MessageLen) ;
      gnat.sockets.send_socket( destination.mysocket , imgbytes(1..actualsize) , actualsent , destination.server ) ;
      if actualsent /= actualsize
      then
         raise Program_Error with "message truncation" ;
      else
         put_line("Message sent");
      end if ;
   exception
      when others =>
         put_line("Exception sending a log message to a socket");
   end SendMessage ;

begin
   SetDestination (new StdOutDestination_Type);
end logging.client;
