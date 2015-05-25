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

package body logging.server is

   package Convert is new system.Address_To_Access_Conversions( logging.LogPacket_Type ) ;
   procedure SetSource (source : Source_type) is
   begin
      Current_Source := source ;
   end ;

   --------------------
   -- LogServer_Type --
   --------------------

   task body LogServer_Type is
      mysocket : gnat.sockets.Socket_Type ;
      myaddr : gnat.sockets.Sock_Addr_Type ;
      logdirname : Unbounded_String := Null_Unbounded_String ;
      logsid : unbounded_string := Null_Unbounded_String ;
      current_logfilename : Unbounded_String := Null_Unbounded_String ;
      current_logfile : Ada.TExt_IO.File_Type ;
      socketoption : gnat.sockets.Option_Type(gnat.sockets.Receive_Timeout) ;
      bufsize : gnat.sockets.option_type(gnat.sockets.Receive_Buffer) ;
      function Generate_New_LogFileName return unbounded_string is
      begin
         return logdirname & logging.time_stamp & logsid ;
      end Generate_New_LogFileName ;
      procedure ReceiveAndLog is
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
      end ReceiveAndLog ;
   begin
      gnat.sockets.Create_Socket(mysocket,mode=>gnat.sockets.Socket_Datagram) ;
      myaddr.Addr := gnat.sockets.Any_Inet_Addr ;
      accept Initialize( port : integer ;
                         logdir : string ;
                         logfileid : string )
      do
         myaddr.Port := gnat.sockets.port_type(port) ;
         gnat.sockets.Bind_Socket( mysocket ,myaddr) ;
         logdirname := to_unbounded_string(logdir) ;
         logsid := to_unbounded_string(logfileid) ;
      end Initialize ;
      socketoption.Timeout := 1.0 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => socketoption ) ;
      bufsize.Size := 1024*1024 ;
      gnat.sockets.Set_Socket_Option( mysocket , option => bufsize ) ;
      current_logfilename := Generate_New_LogFileName ;
      put("Opening File " ); put_line(to_string(current_logfilename)) ;
      logging.SetDestination( logging.Destination_Access_Type(logging.Create(to_string(current_logfilename)) ) );
      loop
         pragma Debug(put_line("Wait for another rendezvous"));
         select
            accept StartNewLog( currentfile : out unbounded_string ) do
               currentfile := Generate_New_LogFileName ;
            end StartNewLog ;
         else
              ReceiveAndLog ;
         end select ;
      end loop ;
      exception
         when Error : others =>
            Ada.Text_IO.Put("Exception: ");
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Name(Error));
            Ada.Text_IO.Put_Line(Ada.Exceptions.Exception_Message(Error));
   end LogServer_Type;

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
   logging.server.LogServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   for i in 1..10
   loop
      delay 2.0 ;
      logging.server.LogServer.StartNewLog(nextlog) ;
      put("New File "); put_line(to_string(nextlog)) ;
   end loop ;
   abort logging.server.Compressor ;
   abort Logging.server.LogServer ;
   put_line("Aborted all tasks");
end SelfTest ;
end logging.server;
