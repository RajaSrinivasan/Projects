with Ada.Text_IO; use Ada.Text_IO;
with Ada.Exceptions;
with GNAT.Time_Stamp;

package body logging.client is

   Current_Max_Message_Level : message_level_type := message_level_type'Last;

   procedure SetSource (name : String) is
   begin
      Register(name) ;
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

   function Create
     (host : String;
      port : Integer) return DatagramDestinationAccess_Type
   is
      newserver : DatagramDestinationAccess_Type :=
        new DatagramDestination_Type;
      he : GNAT.Sockets.Host_Entry_Type :=
        GNAT.Sockets.Get_Host_By_Name (host);
      bufsize : GNAT.Sockets.Option_Type (GNAT.Sockets.Send_Buffer);
   begin
      newserver.server.Addr := GNAT.Sockets.Addresses (he);
      newserver.server.Port := GNAT.Sockets.Port_Type (port);
      GNAT.Sockets.Create_Socket
        (newserver.mysocket,
         Mode => GNAT.Sockets.Socket_Datagram);
      bufsize.Size := 1024 * 1024;
      GNAT.Sockets.Set_Socket_Option (newserver.mysocket, Option => bufsize);
      return newserver;
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
         raise;
   end Create;

   procedure SendMessage
     (destination : DatagramDestination_Type;
      packet      : LogPacket_Type)
   is
      sendpacket : LogPacket_Type := packet;
      imgbytes   : Ada.Streams.Stream_Element_Array (1 .. packet'Size / 8);
      for imgbytes'Address use sendpacket'Address;
      actualsize, actualsent : Ada.Streams.Stream_Element_Offset;
   begin
      sendpacket.hdr.source := Current_Source;
      actualsize            :=
        Stream_Element_Offset
          (imgbytes'Length - MAX_MESSAGE_LENGTH + packet.MessageLen);
      GNAT.Sockets.Send_Socket
        (destination.mysocket,
         imgbytes (1 .. actualsize),
         actualsent,
         destination.server);
      if actualsent /= actualsize then
         raise Program_Error with "message truncation";
      else
         Put_Line ("Sent " & sendpacket.message (1 .. sendpacket.MessageLen));
      end if;
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
   end SendMessage;
   procedure Close (destination : in out DatagramDestination_Type) is
   begin
      GNAT.Sockets.Close_Socket (destination.mysocket);
   end Close;
   procedure SendRecord
     (Destination : DatagramDestination_Type;
      Packet      : BinaryPacket_Type)
   is
   begin
      null;
   end SendRecord;

begin
   SetDestination (new StdOutDestination_Type);
end logging.client;
