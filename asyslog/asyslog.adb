
with logging.client ;
procedure asyslog is
   use logging ;
begin
   logging.SelfTest ;
   logging.RegisterAll("Loggers.txt");

   logging.client.SetSource("One") ;
   logging.client.log(logging.WARNING,"Message 1") ;
   logging.client.log(logging.CRITICAL,"Message 2") ;
   logging.client.log(logging.ERROR,"Message 3") ;
   logging.client.log(logging.INFORMATIONAL,"Message 4") ;
   logging.client.log(logging.WARNING,"Message 5") ;

   logging.client.SetDestination( Destination_Access_Type(Logging.Create("asyslog.log") ) ) ;
   logging.client.SetSource("Two") ;
   logging.client.SetFilter( logging.ERROR ) ;
   logging.client.log(logging.WARNING,"Message 1","C") ;
   logging.client.log(logging.CRITICAL,"Message 2","CL") ;
   logging.client.log(logging.ERROR,"Message 3","CLASS 1") ;
   logging.client.log(logging.INFORMATIONAL,"Message 4","CLASS123") ;
   logging.client.log(logging.WARNING,"Message 5") ;


   logging.client.SetDestination( Destination_Access_Type(Logging.client.Create("192.168.1.5",8689) ) ) ;

   logging.client.SetSource("Two") ;
   logging.client.SetFilter( logging.ERROR ) ;
   logging.client.log(logging.WARNING,"Message 1","C") ;
   logging.client.log(logging.CRITICAL,"Message 2","CL") ;
   logging.client.log(logging.ERROR,"Message 3","CLASS 1") ;
   logging.client.log(logging.INFORMATIONAL,"Message 4","CLASS123") ;
   logging.client.log(logging.WARNING,"Message 5") ;

end asyslog ;
