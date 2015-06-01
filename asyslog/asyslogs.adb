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
      logging.server.LogStreamServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   else
      logging.server.LogDatagramServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   end if ;
   for i in 1..10
   loop
      delay 10.0 * 60.0 ;
      logging.server.LogStreamServer.StartNewLog(nextlog) ;
      put("New File "); put_line(to_string(nextlog)) ;
   end loop ;
end asyslogs ;
