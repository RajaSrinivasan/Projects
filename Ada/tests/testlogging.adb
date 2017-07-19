with logging ; use logging ;
with logging.client ; use logging.client ;

procedure testlogging is
   dest :  Destination_Access_Type := new logging.StdOutDestination_Type ;
begin
    logging.client.SetSource("1") ;
    logging.SetDestination( dest ) ;
   logging.client.SetFilter(logging.WARNING) ;
   logging.client.log( logging.CRITICAL , "Critical") ;
   for severity in logging.message_level_type'first .. logging.INFORMATIONAL
   loop
      logging.client.log( severity , "Message Severity " & logging.image(severity) , class => "unittest" ) ;
   end loop ;

end testlogging ;
