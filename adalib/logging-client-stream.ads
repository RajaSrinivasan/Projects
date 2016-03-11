package logging.client.stream is

   type StreamDestination_Type is new Destination_Type with record
      mysocket : GNAT.Sockets.Socket_Type;
      server   : GNAT.Sockets.Sock_Addr_Type;
   end record;
   type StreamDestinationAccess_Type is access all StreamDestination_Type;
   function Create
     (host : String;
      port : Integer) return StreamDestinationAccess_Type;

   type StreamLogPacket_Type is record
      Size : Short_Integer;
      Pkt  : LogPacket_Type;
   end record;
private
   procedure SendMessage
     (destination : StreamDestination_Type;
      packet      : LogPacket_Type);

   procedure Close (destination : in out StreamDestination_Type);

   procedure SendRecord
     (Destination : StreamDestination_Type;
      Packet      : BinaryPacket_Type);

end logging.client.stream;
