with calendar ;
with ada.strings.unbounded ; use ada.strings.unbounded ;

package logging.server is
   task type LogServer_Type is
      entry Initialize( port : integer ;
                        logdir : string ;
                        logfileid : string ) ;
      entry StartNewLog( currentfile : out unbounded_string ) ;
   end LogServer_Type ;
   LogServer : LogServer_Type ;
   task type Compressor_Type is
      entry Compress( name : string ;
                      outputdir : unbounded_string := Null_Unbounded_String ;
                      removeold : boolean := true ) ;
   end Compressor_Type;
   Compressor : Compressor_Type ;

   procedure SelfTEst ;

end logging.server ;
