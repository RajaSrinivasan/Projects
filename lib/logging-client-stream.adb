package body logging.client.stream is

   ------------
   -- Create --
   ------------

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

   end Create;

   -----------------
   -- SendMessage --
   -----------------

   procedure SendMessage
     (destination : StreamDestination_Type;
      packet      : LogPacket_Type)
   is
   begin
      --  Generated stub: replace with real body!
      pragma Compile_Time_Warning (Standard.True, "SendMessage unimplemented");
      raise Program_Error with "Unimplemented procedure SendMessage";
   end SendMessage;

end logging.client.stream;
