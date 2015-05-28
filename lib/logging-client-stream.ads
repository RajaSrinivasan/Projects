package logging.client.stream is
   type StreamDestination_Type is new Destination_Type with
      record
         mysocket : gnat.sockets.socket_Type ;
         server : gnat.sockets.Sock_Addr_Type ;
      end record ;
   type StreamDestinationAccess_Type is access all StreamDestination_Type ;
   function Create(host : string ;
                   port : integer )
                   return StreamDestinationAccess_Type ;
private
   procedure SendMessage
     (destination : StreamDestination_Type;
      packet      : LogPacket_Type);
end logging.client.stream ;
