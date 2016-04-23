with Ada.Command_Line ;
with Text_Io; use Text_Io ;
with logging.client.stream ;
procedure asyslog is
   use logging ;
begin
   
   -- logging.SelfTest ;
   logging.RegisterAll("Loggers.txt");
   if Ada.Command_Line.Argument_Count >= 1
   then
      Put_Line("Registering " & Ada.Command_Line.Argument(1));
      Logging.Client.SetSource(Ada.Command_Line.Argument(1));
   else
      Put_Line("Registering One");
      Logging.Client.SetSource("One");
   end if ;
   

   logging.client.log(logging.WARNING,"Message 1") ;
   logging.client.log(logging.CRITICAL,"Message 2") ;
   logging.client.log(logging.ERROR,"Message 3") ;
   logging.client.log(logging.INFORMATIONAL,"Message 4") ;
   logging.client.log(logging.WARNING,"Message 5") ;

   logging.SetDestination( Destination_Access_Type(Logging.Create("asyslog.log") ) ) ;

   logging.client.SetFilter( logging.ERROR ) ;
   logging.client.log(logging.WARNING,"Message 1","C") ;
   logging.client.log(logging.CRITICAL,"Message 2","CL") ;
   logging.client.log(logging.ERROR,"Message 3","CLASS 1") ;
   logging.client.log(logging.INFORMATIONAL,"Message 4","CLASS123") ;
   logging.client.log(logging.WARNING,"Message 5") ;


   logging.SetDestination( Destination_Access_Type(Logging.client.stream.Create("localhost",8986) ) ) ;


   logging.client.SetFilter( logging.ERROR ) ;
   for i in 1..100
   loop
      logging.client.log(logging.WARNING,"Message 1","C") ;
      logging.client.log(logging.CRITICAL,"Critical Message " & integer'image(i) ,"CL") ;
      delay 0.1 ;
      logging.client.log(logging.INFORMATIONAL,"Message 4","CLASS123") ;
      logging.client.log(logging.ERROR,"Error Message " & integer'image(i) ,"CLASS 1") ;
      logging.client.log(logging.WARNING,"Message 5") ;
      delay 0.1 ;
   end loop;

end asyslog ;
