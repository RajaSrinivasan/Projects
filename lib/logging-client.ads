with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with gnat.sockets ;

package logging.client is

   procedure SetDestination (destination : Destination_Access_Type);

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

   function Create(ipaddress : string ;
                   port : integer )
                   return DatagramDestinationAccess_Type ;

private
   procedure SendMessage
     (destination : DatagramDestination_Type;
      packet      : LogPacket_Type);
end logging.client;
