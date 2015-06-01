with system.Address_To_Access_Conversions ;
with ada.strings.maps ;
with ada.calendar.formatting ;
with ada.calendar.time_zones ;
with ada.exceptions ;

with Ada.Text_IO ; use Ada.Text_IO ;
with gnat.sockets ;
with gnat.Directory_Operations ;
with gnat.time_stamp ;

with logging.client ;
with logging.client.stream ;

package body logging.server is

   package Convert is new system.Address_To_Access_Conversions( logging.LogPacket_Type ) ;
   procedure SetSource (source : Source_type) is
   begin
      Current_Source := source ;
   end ;


   function Generate_New_LogFileName(dirname : ada.strings.unbounded.Unbounded_String;
                                     id : ada.strings.unbounded.unbounded_string ) return unbounded_string is
   begin
      return dirname & logging.time_stamp & id ;
   end Generate_New_LogFileName ;
   --------------------
   -- LogServer_Type --
   --------------------

   task body LogDatagramServer_Type is
      mysocket : gnat.sockets.Socket_Type ;
      myaddr : gnat.sockets.Sock_Addr_Type ;
      logdirname : Unbounded_String := Null_Unbounded_String ;
      logsid : unbounded_string := Null_Unbounded_String ;
      current_logfilename : Unbounded_String := Null_Unbounded_String ;
      current_logfile : Ada.TExt_IO.File_Type ;
      socketoption : gnat.sockets.Option_Type(gnat.sockets.Receive_Timeout) ;
      bufsize : gnat.sockets.option_type(gnat.sockets.Receive_Buffer) ;

      procedure ReceiveAndLogDatagram is
         msgreceived : Ada.Streams.Stream_Element_Array (1..logging.LogPacket_Type'Size/8) ;
         msgrlength : Ada.Streams.Stream_Element_Offset ;
         pktreceived : Convert.Object_Pointer ;
      begin
         loop
            gnat.sockets.Receive_Socket( mysocket , msgreceived , msgrlength ) ;
            pktreceived := Convert.To_Pointer(msgreceived'address) ;
            pragma Debug(put_line("Got a message." & pktreceived.message(1..pktreceived.messagelen))) ;
            logging.server.SetSource( pktreceived.hdr.source ) ;
            logging.client.Log( pktreceived.level , pktreceived.message(1..pktreceived.messagelen) , pktreceived.class ) ;
         end loop ;
      exception
         when Error : others => null ;
      end ReceiveAndLogDatagram ;

   begin

         accept Initialize( port : integer ;
                         logdir : string ;
                         logfileid : string )
         do
            gnat.sockets.Create_Socket(mysocket,mode=>gnat.sockets.Socket_Datagram) ;
            myaddr.Addr := gnat.sockets.Any_Inet_Addr ;
            myaddr.Port := gnat.sockets.port_type(port) ;
            gnat.sockets.Bind_Socket( mysocket ,myaddr) ;
            logdirname := to_unbounded_string(logdir) ;
            logsid := to_unbounded_string(logfileid) ;
         end Initialize ;

      socketoption.Timeout := 1.0 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => socketoption ) ;
      bufsize.Size := 1024*1024 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => bufsize ) ;
      current_logfilename := Generate_New_LogFileName(logdirname,logsid) ;
      put("Opening File " ); put_line(to_string(current_logfilename)) ;
      logging.SetDestination( logging.Destination_Access_Type(logging.Create(to_string(current_logfilename)) ) );
      loop
         pragma Debug(put_line("Wait for another rendezvous"));
         select
            accept StartNewLog( currentfile : out unbounded_string ) do
               currentfile := Generate_New_LogFileName (logdirname,logsid);
            end StartNewLog ;
         else
            ReceiveAndLogDatagram ;
         end select ;
      end loop ;
      exception
         when Error : others =>
            Ada.Text_IO.Put("Exception: ");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
   end LogDatagramServer_Type;

   task body LogStreamServer_Type is
      mysocket : gnat.sockets.Socket_Type ;
      myaddr : gnat.sockets.Sock_Addr_Type ;

      logdirname : Unbounded_String := Null_Unbounded_String ;
      logsid : unbounded_string := Null_Unbounded_String ;
      current_logfilename : Unbounded_String := Null_Unbounded_String ;
      current_logfile : Ada.TExt_IO.File_Type ;
      socketoption : gnat.sockets.Option_Type(gnat.sockets.Receive_Timeout) ;
      bufsize : gnat.sockets.option_type(gnat.sockets.Receive_Buffer) ;
   begin
      accept Initialize( port : integer ;
                         logdir : string ;
                         logfileid : string ) do
         gnat.sockets.Create_Socket(mysocket,mode=>gnat.sockets.Socket_Stream) ;
         myaddr.Addr := gnat.sockets.Any_Inet_Addr ;
         myaddr.Port := gnat.sockets.port_type(port) ;
         gnat.sockets.Bind_Socket( mysocket ,myaddr) ;
         logdirname := to_unbounded_string(logdir) ;
         logsid := to_unbounded_string(logfileid) ;
      end Initialize ;
      current_logfilename := Generate_New_LogFileName (logdirname,logsid);
      put("Opening File " ); put_line(to_string(current_logfilename)) ;
      logging.SetDestination( logging.Destination_Access_Type(logging.Create(to_string(current_logfilename)) ) );

      socketoption.Timeout := 1.0 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => socketoption ) ;
      bufsize.Size := 1024*1024 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => bufsize ) ;
      gnat.sockets.Listen_Socket( mysocket ) ;
      loop
         pragma Debug(put_line("Wait for another rendezvous"));
         select
            accept StartNewLog( currentfile : out unbounded_string ) do
               currentfile := Generate_New_LogFileName(logdirname,logsid) ;
            end StartNewLog ;
         else
            declare
               use gnat.sockets ;
               clientsocket : gnat.sockets.socket_type ;
               clientaddr : gnat.sockets.Sock_Addr_Type ;
               accstatus : gnat.sockets.Selector_Status ;
               sockserver : SockServer_PtrType ;
            begin
               gnat.sockets.accept_socket( mysocket , clientsocket , clientaddr , 5.0 , status => accstatus ) ;
               if accstatus = gnat.sockets.Completed
               then
                  pragma Debug(put_line("Received a connection")) ;
                  sockserver := new SockServer_Type ;
                  sockserver.Serve( clientsocket ) ;
               end if;
            end ;
         end select ;
      end loop ;
   end LogStreamServer_Type ;

   ClientExited : exception ;

   task body SockServer_Type is
      mysocket : gnat.sockets.Socket_Type ;
      procedure ReceiveAndLogMessages is
         streamlog : logging.client.stream.StreamLogPacket_Type ;
         hdrtobereceived : Ada.Streams.Stream_Element_Array( 1..streamlog.Size'size/8 ) ;
         for hdrtobereceived'address use streamlog.Size'Address ;
         procedure Receive_Bytes( bufferptr : system.address ; bufsize : integer ) is
            datatobereceived : Ada.Streams.Stream_Element_Array(1..Stream_Element_Offset(bufsize)) ;
            for datatobereceived'address use bufferptr ;
            firstbytetoreceive : Ada.Streams.Stream_Element_Offset := 1 ;
            recvbytelast : Ada.Streams.Stream_Element_Offset := 0 ;
         begin
            pragma Debug(put_line("ReceiveBytes " & integer'image(bufsize)));
            while recvbytelast < Stream_Element_Offset(bufsize)
            loop
               gnat.sockets.receive_socket( mysocket , datatobereceived(firstbytetoreceive..datatobereceived'last) , recvbytelast ) ;
               if recvbytelast = 0
               then
                  raise ClientExited ;
               end if ;
               firstbytetoreceive := recvbytelast + 1;
            end loop;
         exception
            when ClientExited =>
               raise ;
            when sockerror : gnat.sockets.Socket_error =>
               raise ClientExited ;
            when Error : others =>
               Ada.Text_IO.Put("Exception: ReceiveBytes ");
               Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
               Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
         end Receive_Bytes ;
      begin
         loop
            streamlog.pkt.MessageLen := 0 ;
            Receive_Bytes( streamlog.Size'Address , streamlog.Size'size/8 ) ;
            Receive_Bytes( streamlog.pkt'Address , integer(streamlog.size) ) ;
            pragma Debug(put_line("Message received. Size " & short_integer'image(streamlog.size) ));
            logging.client.Log( streamlog.Pkt.level , streamlog.Pkt.message(1..streamlog.Pkt.MessageLen) , streamlog.Pkt.class ) ;
         end loop ;
      exception
         when ClientExited =>
            pragma Debug(put_line("Client Has exited")) ;
            gnat.Sockets.close_socket(mysocket) ;
         when Error : others =>
            Ada.Text_IO.Put("Exception: ReceiveAndLogMessages ");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
      end ReceiveAndLogMessages ;
   begin
      accept Serve( socket : gnat.sockets.socket_type ) do
         mysocket := socket ;
      end Serve ;
      pragma Debug(put_line("Starting a socket server"));
      ReceiveAndLogMessages ;
      pragma Debug(Put_Line("Socket Server Exiting"));
   end SockServer_Type ;
   ---------------------
   -- Compressor_Type --
   ---------------------

   task body Compressor_Type is
      filenametocompress : unbounded_string ;
      destdir : unbounded_string ;
      removeoldfile : boolean ;
   begin
      loop
         accept Compress( name : string ;
                          outputdir : unbounded_string := Null_Unbounded_String ;
                          removeold : boolean := true ) do
            filenametocompress := to_unbounded_string(name) ;
            destdir := outputdir ;
            removeoldfile := removeold ;
         end Compress ;
      end loop ;
   end Compressor_Type;
procedure SelfTEst is
   nextlog : unbounded_string ;
begin
   logging.server.LogDatagramServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   for i in 1..10
   loop
      delay 2.0 ;
      logging.server.LogDatagramServer.StartNewLog(nextlog) ;
      put("New File "); put_line(to_string(nextlog)) ;
   end loop ;
      abort logging.server.Compressor ;
      abort Logging.server.LogDatagramServer ;
      abort Logging.server.LogStreamServer ;
   put_line("Aborted all tasks");
end SelfTest ;
end logging.server;
