with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with gnat.sockets ;

package logging.client is

   procedure SetSource (name : String);
   procedure SetFilter (max : message_level_type);
   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class);

   type DatagramDestination_Type is new Destination_Type with
      record
         mysocket : gnat.sockets.socket_Type ;
         server : gnat.sockets.Sock_Addr_Type ;
      end record ;
   type DatagramDestinationAccess_Type is access all DatagramDestination_Type ;

   function Create(host : string ;
                   port : integer )
                   return DatagramDestinationAccess_Type ;

private
   procedure SendMessage
     (destination : DatagramDestination_Type;
      packet      : LogPacket_Type);
<<<<<<< HEAD
   procedure Close(destination : in out DatagramDestination_Type) ;
=======
   procedure SendRecord
     (Destination : DatagramDestination_Type;
      Packet      : BinaryPacket_Type) ;   
>>>>>>> 542fb369b0cdd16c1dc7d3974d10bc681d89861d
end logging.client;
