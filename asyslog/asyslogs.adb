with ada.text_io; use ada.text_io;
with ada.strings.Unbounded ; use ada.strings.Unbounded ;
with logging.client ;
with logging.server ;
with ada.command_line ;
with gnat.Directory_Operations ;

procedure asyslogs is
   nextlog : unbounded_string ;
begin
   logging.RegisterAll("Loggers.txt") ;
   if ada.command_line.Argument_Count >= 1
   then
      Put_Line("Starting a stream socket server");
      logging.server.LogStreamServer.Initialize( 8986 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   else
      Put_Line("Starting a Datagram socket server");
      logging.server.LogDatagramServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   end if ;
   Put_Line("Will now periodically change the log file name");
   for i in 1..10
   loop
      delay 10.0 * 60.0 ;
      logging.server.LogStreamServer.StartNewLog(nextlog) ;
      put("New File "); put_line(to_string(nextlog)) ;
   end loop ;
end asyslogs ;
