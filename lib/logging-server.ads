with Calendar;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Sockets;

package logging.server is

   procedure SetSource (source : Source_type);

   task type LogDatagramServer_Type is
      entry Initialize (port : Integer; logdir : String; logfileid : String);
      entry StartNewLog (currentfile : out Unbounded_String);
   end LogDatagramServer_Type;
   LogDatagramServer : LogDatagramServer_Type;

   task type LogStreamServer_Type is
      entry Initialize (port : Integer; logdir : String; logfileid : String);
      entry StartNewLog (currentfile : out Unbounded_String);
   end LogStreamServer_Type;
   LogStreamServer : LogStreamServer_Type;

   task type SockServer_Type is
      entry Serve (socket : GNAT.Sockets.Socket_Type);
   end SockServer_Type;
   type SockServer_PtrType is access all SockServer_Type;

   task type Compressor_Type is
      entry Compress
        (name      : String;
         outputdir : Unbounded_String := Null_Unbounded_String;
         removeold : Boolean          := True);
   end Compressor_Type;
   Compressor : Compressor_Type;

   procedure SelfTEst;

end logging.server;
