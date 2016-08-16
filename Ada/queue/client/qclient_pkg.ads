package Qclient_Pkg is
   procedure SetServer( NodeName : String ;
			ServerPort : Integer ) ;
   procedure ShowJobs ;   
   procedure Submit( Script : String ;
		     EnvironmentFile : String ) ;
end Qclient_Pkg ;
