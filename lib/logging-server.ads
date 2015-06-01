with calendar ;
with ada.strings.unbounded ; use ada.strings.unbounded ;
with gnat.sockets ;

package logging.server is

   procedure SetSource (source : Source_type);

   task type LogDatagramServer_Type is
      entry Initialize( port : integer ;
                        logdir : string ;
                        logfileid : string ) ;
      entry StartNewLog( currentfile : out unbounded_string ) ;
   end LogDatagramServer_Type ;
   LogDatagramServer : LogDatagramServer_Type ;

   task type LogStreamServer_Type is
      entry Initialize( port : integer ;
                        logdir : string ;
                        logfileid : string ) ;
      entry StartNewLog( currentfile : out unbounded_string ) ;
   end LogStreamServer_Type ;
   LogStreamServer : LogStreamServer_Type ;

   task type SockServer_Type is
      entry Serve( socket : gnat.sockets.socket_type ) ;
   end SockServer_Type ;
   type SockServer_PtrType is access all SockServer_Type ;

   task type Compressor_Type is
      entry Compress( name : string ;
                      outputdir : unbounded_string := Null_Unbounded_String ;
                      removeold : boolean := true ) ;
   end Compressor_Type;
   Compressor : Compressor_Type ;

   procedure SelfTEst ;

end logging.server ;
