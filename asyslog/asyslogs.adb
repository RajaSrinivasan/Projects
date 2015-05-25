with ada.text_io; use ada.text_io;
with ada.strings.Unbounded ; use ada.strings.Unbounded ;
with logging.client ;
with logging.server ;
with gnat.Directory_Operations ;

procedure asyslogs is
   nextlog : unbounded_string ;
begin
   logging.RegisterAll("Loggers.txt") ;
   logging.server.LogServer.Initialize( 8689 , gnat.Directory_Operations.Get_Current_Dir , "oplog.log" ) ;
   for i in 1..10
   loop
      delay 10.0 * 60.0 ;
      logging.server.LogServer.StartNewLog(nextlog) ;
      put("New File "); put_line(to_string(nextlog)) ;
   end loop ;
end asyslogs ;
