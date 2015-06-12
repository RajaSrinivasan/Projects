with Ada.Exceptions;
package body logging.client.stream is

   function Create
     (host : String;
      port : Integer) return StreamDestinationAccess_Type
   is
      newserver : StreamDestinationAccess_Type := new StreamDestination_Type;
      he        : GNAT.Sockets.Host_Entry_Type :=
        GNAT.Sockets.Get_Host_By_Name (host);
   begin
      GNAT.Sockets.Create_Socket
        (newserver.mysocket,
         Mode => GNAT.Sockets.Socket_Stream);
      newserver.server.Addr := GNAT.Sockets.Addresses (he);
      newserver.server.Port := GNAT.Sockets.Port_Type (port);
      GNAT.Sockets.Connect_Socket (newserver.mysocket, newserver.server);
      return newserver;
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
         raise;
   end Create;
   -----------------
   -- SendMessage --
   -----------------
   streamlog : StreamLogPacket_Type;
   procedure SendMessage
     (destination : StreamDestination_Type;
      packet      : LogPacket_Type)
   is

      procedure SendBytes (bufferptr : System.Address; bufsize : Integer) is
         tobesent : Ada.Streams
           .Stream_Element_Array
         (1 .. Stream_Element_Offset (bufsize));
         for tobesent'Address use bufferptr;
         firstbytetosend : Ada.Streams.Stream_Element_Offset := 1;
         sentbytelast    : Ada.Streams.Stream_Element_Offset := 0;
      begin
         while sentbytelast < Stream_Element_Offset (bufsize) loop
            GNAT.Sockets.Send_Socket
              (destination.mysocket,
               tobesent (firstbytetosend .. Stream_Element_Offset (bufsize)),
               sentbytelast,
               null);
         end loop;
      end SendBytes;

   begin
      streamlog.Size :=
        Short_Integer
          (packet'Size / 8 - MAX_MESSAGE_LENGTH + packet.MessageLen);
      pragma Debug
        (Put_Line
           ("Will Send " &
            Short_Integer'Image (streamlog.Size) &
            " bytes. for Message of length " &
            Natural'Image (packet.MessageLen)));
      streamlog.Pkt := packet;
      SendBytes (streamlog.Size'Address, streamlog.Size'Size / 8);
      SendBytes (streamlog.Pkt'Address, Integer (streamlog.Size));
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
         raise;
   end SendMessage;
   procedure Close (destination : in out StreamDestination_Type) is
   begin
      GNAT.Sockets.Close_Socket (destination.mysocket);
   end Close;
   procedure SendRecord
     (Destination : StreamDestination_Type;
      Packet      : BinaryPacket_Type)
   is
   begin
      null;
   end SendRecord;

end logging.client.stream;
