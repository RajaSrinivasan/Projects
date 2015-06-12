with System.Address_To_Access_Conversions;
with Ada.Strings.Maps;
with Ada.Calendar.Formatting;
with Ada.Calendar.Time_Zones;
with Ada.Exceptions;

with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Sockets;
with GNAT.Directory_Operations;
with GNAT.Time_Stamp;

with logging.client;
with logging.client.stream;

package body logging.server is

   package Convert is new System.Address_To_Access_Conversions
     (logging.LogPacket_Type);
   procedure SetSource (source : Source_type) is
   begin
      Current_Source := source;
   end SetSource;

   function Generate_New_LogFileName
     (dirname : Ada.Strings.Unbounded.Unbounded_String;
      id      : Ada.Strings.Unbounded.Unbounded_String) return Unbounded_String
   is
   begin
      return dirname & logging.Time_Stamp & id;
   end Generate_New_LogFileName;
   --------------------
   -- LogServer_Type --
   --------------------

   task body LogDatagramServer_Type is
      mysocket            : GNAT.Sockets.Socket_Type;
      myaddr              : GNAT.Sockets.Sock_Addr_Type;
      logdirname          : Unbounded_String := Null_Unbounded_String;
      logsid              : Unbounded_String := Null_Unbounded_String;
      current_logfilename : Unbounded_String := Null_Unbounded_String;
      current_logfile     : Ada.Text_IO.File_Type;
      socketoption : GNAT.Sockets.Option_Type (GNAT.Sockets.Receive_Timeout);
      bufsize : GNAT.Sockets.Option_Type (GNAT.Sockets.Receive_Buffer);

      procedure ReceiveAndLogDatagram is
         msgreceived : Ada.Streams
           .Stream_Element_Array
         (1 .. logging.LogPacket_Type'Size / 8);
         msgrlength  : Ada.Streams.Stream_Element_Offset;
         pktreceived : Convert.Object_Pointer;
      begin
         loop
            GNAT.Sockets.Receive_Socket (mysocket, msgreceived, msgrlength);
            pktreceived := Convert.To_Pointer (msgreceived'Address);
            pragma Debug
              (Put_Line
                 ("Got a message." &
                  pktreceived.message (1 .. pktreceived.MessageLen)));
            logging.server.SetSource (pktreceived.hdr.source);
            logging.client.log
              (pktreceived.level,
               pktreceived.message (1 .. pktreceived.MessageLen),
               pktreceived.class);
         end loop;
      exception
         when Error : others =>
            null;
      end ReceiveAndLogDatagram;

   begin

      accept Initialize
        (port      : Integer;
         logdir    : String;
         logfileid : String) do
         GNAT.Sockets.Create_Socket
           (mysocket,
            Mode => GNAT.Sockets.Socket_Datagram);
         myaddr.Addr := GNAT.Sockets.Any_Inet_Addr;
         myaddr.Port := GNAT.Sockets.Port_Type (port);
         GNAT.Sockets.Bind_Socket (mysocket, myaddr);
         logdirname := To_Unbounded_String (logdir);
         logsid     := To_Unbounded_String (logfileid);
      end Initialize;

      socketoption.Timeout := 1.0;
      GNAT.Sockets.Set_Socket_Option (mysocket, Option => socketoption);
      bufsize.Size := 1024 * 1024;
      GNAT.Sockets.Set_Socket_Option (mysocket, Option => bufsize);
      current_logfilename := Generate_New_LogFileName (logdirname, logsid);
      Put ("Opening File ");
      Put_Line (To_String (current_logfilename));
      logging.SetDestination
        (logging.Destination_Access_Type
           (logging.Create (To_String (current_logfilename))));
      loop
         pragma Debug (Put_Line ("Wait for another rendezvous"));
         select
            accept StartNewLog (currentfile : out Unbounded_String) do
               currentfile := current_logfilename;
            end StartNewLog;
            current_logfilename :=
              Generate_New_LogFileName (logdirname, logsid);
            Put ("Opening File ");
            Put_Line (To_String (current_logfilename));
            logging.SetDestination
              (logging.Destination_Access_Type
                 (logging.Create (To_String (current_logfilename))));
         else
            ReceiveAndLogDatagram;
         end select;
      end loop;
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
   end LogDatagramServer_Type;

   task body LogStreamServer_Type is
      mysocket : GNAT.Sockets.Socket_Type;
      myaddr   : GNAT.Sockets.Sock_Addr_Type;

      logdirname          : Unbounded_String := Null_Unbounded_String;
      logsid              : Unbounded_String := Null_Unbounded_String;
      current_logfilename : Unbounded_String := Null_Unbounded_String;
      current_logfile     : Ada.Text_IO.File_Type;
      socketoption : GNAT.Sockets.Option_Type (GNAT.Sockets.Receive_Timeout);
      bufsize : GNAT.Sockets.Option_Type (GNAT.Sockets.Receive_Buffer);
   begin
      accept Initialize
        (port      : Integer;
         logdir    : String;
         logfileid : String) do
         GNAT.Sockets.Create_Socket
           (mysocket,
            Mode => GNAT.Sockets.Socket_Stream);
         myaddr.Addr := GNAT.Sockets.Any_Inet_Addr;
         myaddr.Port := GNAT.Sockets.Port_Type (port);
         GNAT.Sockets.Bind_Socket (mysocket, myaddr);
         logdirname := To_Unbounded_String (logdir);
         logsid     := To_Unbounded_String (logfileid);
      end Initialize;
      current_logfilename := Generate_New_LogFileName (logdirname, logsid);
      Put ("Opening File ");
      Put_Line (To_String (current_logfilename));
      logging.SetDestination
        (logging.Destination_Access_Type
           (logging.Create (To_String (current_logfilename))));

      socketoption.Timeout := 1.0;
      GNAT.Sockets.Set_Socket_Option (mysocket, Option => socketoption);
      bufsize.Size := 1024 * 1024;
      GNAT.Sockets.Set_Socket_Option (mysocket, Option => bufsize);
      GNAT.Sockets.Listen_Socket (mysocket);
      loop
         pragma Debug (Put_Line ("Wait for another rendezvous"));
         select
            accept StartNewLog (currentfile : out Unbounded_String) do
               currentfile         := current_logfilename;
               current_logfilename :=
                 Generate_New_LogFileName (logdirname, logsid);
               Put ("Opening File ");
               Put_Line (To_String (current_logfilename));
               logging.SetDestination
                 (logging.Destination_Access_Type
                    (logging.Create (To_String (current_logfilename))));
            end StartNewLog;
         else
            declare
               use GNAT.Sockets;
               clientsocket : GNAT.Sockets.Socket_Type;
               clientaddr   : GNAT.Sockets.Sock_Addr_Type;
               accstatus    : GNAT.Sockets.Selector_Status;
               sockserver   : SockServer_PtrType;
            begin
               GNAT.Sockets.Accept_Socket
                 (mysocket,
                  clientsocket,
                  clientaddr,
                  5.0,
                  Status => accstatus);
               if accstatus = GNAT.Sockets.Completed then
                  pragma Debug (Put_Line ("Received a connection"));
                  sockserver := new SockServer_Type;
                  sockserver.Serve (clientsocket);
               end if;
            end;
         end select;
      end loop;
   exception
      when Error : others =>
         Ada.Text_IO.Put ("Exception: ");
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
         Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
   end LogStreamServer_Type;

   ClientExited : exception;

   task body SockServer_Type is
      mysocket : GNAT.Sockets.Socket_Type;
      procedure ReceiveAndLogMessages is
         streamlog       : logging.client.stream.StreamLogPacket_Type;
         hdrtobereceived : Ada.Streams
           .Stream_Element_Array
         (1 .. streamlog.Size'Size / 8);
         for hdrtobereceived'Address use streamlog.Size'Address;
         procedure Receive_Bytes
           (bufferptr : System.Address;
            bufsize   : Integer)
         is
            datatobereceived : Ada.Streams
              .Stream_Element_Array
            (1 .. Stream_Element_Offset (bufsize));
            for datatobereceived'Address use bufferptr;
            firstbytetoreceive : Ada.Streams.Stream_Element_Offset := 1;
            recvbytelast       : Ada.Streams.Stream_Element_Offset := 0;
         begin
            pragma Debug
              (Put_Line ("ReceiveBytes " & Integer'Image (bufsize)));
            while recvbytelast < Stream_Element_Offset (bufsize) loop
               GNAT.Sockets.Receive_Socket
                 (mysocket,
                  datatobereceived
                    (firstbytetoreceive .. datatobereceived'Last),
                  recvbytelast);
               if recvbytelast = 0 then
                  raise ClientExited;
               end if;
               firstbytetoreceive := recvbytelast + 1;
            end loop;
         exception
            when ClientExited =>
               raise;
            when sockerror : GNAT.Sockets.Socket_Error =>
               raise ClientExited;
            when Error : others =>
               Ada.Text_IO.Put ("Exception: ReceiveBytes ");
               Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
               Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
         end Receive_Bytes;
      begin
         loop
            streamlog.Pkt.MessageLen := 0;
            Receive_Bytes (streamlog.Size'Address, streamlog.Size'Size / 8);
            Receive_Bytes (streamlog.Pkt'Address, Integer (streamlog.Size));
            pragma Debug
              (Put_Line
                 ("Message received. Size " &
                  Short_Integer'Image (streamlog.Size)));
            logging.server.SetSource (streamlog.Pkt.hdr.source);
            logging.client.log
              (streamlog.Pkt.level,
               streamlog.Pkt.message (1 .. streamlog.Pkt.MessageLen),
               streamlog.Pkt.class);
         end loop;
      exception
         when ClientExited =>
            pragma Debug (Put_Line ("Client Has exited"));
            GNAT.Sockets.Close_Socket (mysocket);
         when Error : others =>
            Ada.Text_IO.Put ("Exception: ReceiveAndLogMessages ");
            Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Name (Error));
            Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Message (Error));
      end ReceiveAndLogMessages;
   begin
      accept Serve (socket : GNAT.Sockets.Socket_Type) do
         mysocket := socket;
      end Serve;
      pragma Debug (Put_Line ("Starting a socket server"));
      ReceiveAndLogMessages;
      pragma Debug (Put_Line ("Socket Server Exiting"));
   end SockServer_Type;
   ---------------------
   -- Compressor_Type --
   ---------------------

   task body Compressor_Type is
      filenametocompress : Unbounded_String;
      destdir            : Unbounded_String;
      removeoldfile      : Boolean;
   begin
      loop
         accept Compress
           (name      : String;
            outputdir : Unbounded_String := Null_Unbounded_String;
            removeold : Boolean          := True) do
            filenametocompress := To_Unbounded_String (name);
            destdir            := outputdir;
            removeoldfile      := removeold;
         end Compress;
      end loop;
   end Compressor_Type;
   procedure SelfTEst is
      nextlog : Unbounded_String;
   begin
      logging.server.LogDatagramServer.Initialize
        (8689,
         GNAT.Directory_Operations.Get_Current_Dir,
         "oplog.log");
      for i in 1 .. 10 loop
         delay 2.0;
         logging.server.LogDatagramServer.StartNewLog (nextlog);
         Put ("New File ");
         Put_Line (To_String (nextlog));
      end loop;
      abort logging.server.Compressor;
      abort logging.server.LogDatagramServer;
      abort logging.server.LogStreamServer;
      Put_Line ("Aborted all tasks");
   end SelfTEst;
end logging.server;
