with GNAT.Sockets ;
with Gnatcoll.Json ;

package Queue is
   Verbose : Boolean := True ;   
   Version : constant String := "V01.00.00" ;
   DefaultPort : Integer := 100756 ;
   
   type Packet_Type is
     (
      QUERY , 
      RESPONSE 
     ) ;
   type Services_Type is
     (
       LIST_ALL_JOBS ,
       SUBMIT_JOB ,
       QUERY_JOB ,
       ABORT_JOB ,
       RESTART_MANAGER 
     ) ;
   
   
   type Message_Type is private ;
   
   function Create( Packet : Packet_Type ;
		    Service : Services_Type ) return Message_Type ;
   procedure Set_Argument( Msg : in out Message_Type ;
			   Name : String ;
			   Value : String ) ;
   procedure Send( Destination : GNAT.Sockets.Socket_Type ;
		   Msg : Message_Type ) ;
   procedure Receive( Source : GNAT.Sockets.Socket_Type ;
		      Msg : out Message_Type ) ;
   
   procedure Show( Message : Message_Type ) ;
    
private
   type Message_Type is
      record
	 Contents : GNATCOLL.JSON.JSON_Value ;
      end record ;
end Queue ;
