with ada.exceptions ;
package body logging.client.stream is


   function Create
     (host : string;
      port : integer)
      return StreamDestinationAccess_Type
   is
      newserver : StreamDestinationAccess_Type := new StreamDestination_Type ;
      he : gnat.Sockets.Host_Entry_Type  := gnat.sockets.Get_Host_By_Name( host ) ;
   begin
      gnat.sockets.create_socket(  newserver.mysocket , mode => gnat.sockets.Socket_Stream ) ;
      newserver.server.Addr := gnat.sockets.addresses(he) ;
      newserver.server.port := gnat.sockets.port_type(port) ;
      gnat.sockets.connect_socket( newserver.mysocket , newserver.server ) ;
      return newserver ;
   exception
      when Error : others =>
         Ada.Text_IO.Put("Exception: ");
         Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
         Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
         raise ;
   end Create;

   -----------------
   -- SendMessage --
   -----------------
   streamlog : StreamLogPacket_Type ;
   procedure SendMessage
     (destination : StreamDestination_Type;
      packet      : LogPacket_Type)
   is

      procedure SendBytes( bufferptr : system.address ; bufsize : integer ) is
         tobesent : Ada.Streams.Stream_Element_Array(1..Stream_Element_Offset(bufsize)) ;
         for tobesent'address use bufferptr ;
         firstbytetosend : Ada.Streams.Stream_Element_Offset := 1 ;
         sentbytelast : Ada.Streams.Stream_Element_Offset := 0 ;
      begin
         while sentbytelast < Stream_Element_Offset(bufsize)
         loop
            gnat.sockets.send_socket( destination.mysocket , tobesent(firstbytetosend..Stream_Element_Offset(bufsize)), sentbytelast , null ) ;
         end loop ;
      end SendBytes ;

   begin
      streamlog.Size := Short_Integer(packet'Size/8 - MAX_MESSAGE_LENGTH + packet.MessageLen) ;
      pragma Debug(put_line("Will Send " & short_integer'image(streamlog.Size) & " bytes. for Message of length " & natural'image( packet.MessageLen )));
      streamlog.pkt := packet ;
      SendBytes(streamlog.Size'address,streamlog.Size'size/8) ;
      SendBytes(streamlog.pkt'address,integer(streamlog.Size));
   exception
      when Error : others =>
         Ada.Text_IO.Put("Exception: ");
         Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
         Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
         raise ;
   end SendMessage;

end logging.client.stream;
