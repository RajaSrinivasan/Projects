with logging ; use logging ;
with logging.client ; use logging.client ;

procedure testlogging is
   dest :  Destination_Access_Type := new logging.StdOutDestination_Type ;
begin
    logging.client.SetSource("1") ;
    logging.SetDestination( dest ) ;
    logging.client.SetFilter(logging.INFORMATIONAL) ;
    logging.client.log( logging.CRITICAL , "Critical") ;
end testlogging ;
