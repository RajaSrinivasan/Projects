with ada.strings.maps ;
with ada.calendar.formatting ;
with Ada.Text_IO ; use Ada.Text_IO ;
with gnat.sockets ;
with gnat.Directory_Operations ;

package body logging.server is

   --------------------
   -- LogServer_Type --
   --------------------

   task body LogServer_Type is
      mysocket : gnat.sockets.Socket_Type ;
      myaddr : gnat.sockets.Sock_Addr_Type ;
      logdirname : Unbounded_String := Null_Unbounded_String ;
      logsid : unbounded_string := Null_Unbounded_String ;
      current_logfilename : Unbounded_String := Null_Unbounded_String ;
      function Generate_New_LogFileName return unbounded_string is
         removeset : ada.strings.maps.Character_Set ;
         timestamp : unbounded_string
           := To_Unbounded_String( ada.calendar.formatting.image( ada.calendar.clock ) ) ;
         pos : natural := 0 ;
      begin
         removeset := ada.strings.maps.To_Set("-:. ");
         loop
            pos := ada.strings.unbounded.index( timestamp , removeset ) ;
            if pos = 0
            then
               exit ;
            end if ;
            ada.strings.unbounded.Delete( timestamp , pos , pos ) ;
         end loop ;
         return logdirname & timestamp & logsid ;
      end Generate_New_LogFileName ;

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
      current_logfilename := Generate_New_LogFileName ;
      put("Opening File " ); put_line(to_string(current_logfilename)) ;
      loop
         select
            accept StartNewLog( currentfile : out unbounded_string ) do
               currentfile := Generate_New_LogFileName ;
            end StartNewLog ;
         else
              null ;
         end select ;
      end loop ;
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
