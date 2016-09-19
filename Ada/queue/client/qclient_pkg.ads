package Qclient_Pkg is
   procedure SetServer( NodeName : String ;
			ServerPort : Integer ) ;
   procedure ShowJobs ;   
   procedure Submit( Script : String ;
                     EnvironmentFile : String ) ;
   procedure Delete_Job( JobNo : Integer ) ;
end Qclient_Pkg ;
