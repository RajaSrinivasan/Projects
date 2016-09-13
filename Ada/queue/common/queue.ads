with GNAT.Sockets ;
with Gnatcoll.Json ;

package Queue is
   Verbose : Boolean := True ;
   Version : constant String := "V01.00.02" ;
   DefaultPort : Integer := 10756 ;

   type Packet_Type is
     (
      QUERY ,
      RESPONSE ,
      DONT_UNDERSTAND
     ) ;
   type Services_Type is
     (
       LIST_ALL_JOBS ,
       SUBMIT_JOB ,
       QUERY_JOB ,
       DELETE_JOB ,
       RESTART_MANAGER
     ) ;


   type Message_Type is private ;

   function Create( Packet : Packet_Type ;
                    Service : Services_Type ) return Message_Type ;
   procedure Set_Argument( Msg : in out Message_Type ;
                           Name : String ;
                           Value : String ) ;
   procedure Set_Argument( Msg : in out Message_Type ;
                           Name : String ;
                           Value : Integer ) ;
   procedure Add_File( Msg : in out Message_Type ;
                       Name : String ;
                       Path : String ;
                       Base64 : Boolean := False ) ;
   procedure Send( Destination : GNAT.Sockets.Socket_Type ;
                   Msg : Message_Type ) ;
   procedure Receive( Source : GNAT.Sockets.Socket_Type ;
                      Msg : out Message_Type ) ;

   function Get( Msg : Message_Type ) return Packet_Type ;
   function Get( Msg : Message_Type ) return Services_Type ;
   function Get( Msg : Message_Type ; Name : String ) return String ;
   function Get( Msg : Message_Type ; Name : String ) return Integer ;

   function GetFile( Msg : Message_Type ; Name : String ) return String ;

   procedure Show( Message : Message_Type ) ;

private
   type Message_Type is
      record
         Contents : GNATCOLL.JSON.JSON_Value ;
      end record ;
end Queue ;
