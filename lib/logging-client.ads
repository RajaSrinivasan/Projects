with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with GNAT.Sockets;

package logging.client is

   procedure SetSource (name : String);
   procedure SetFilter (max : message_level_type);
   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class);

   type DatagramDestination_Type is new Destination_Type with record
      mysocket : GNAT.Sockets.Socket_Type;
      server   : GNAT.Sockets.Sock_Addr_Type;
   end record;
   type DatagramDestinationAccess_Type is access all DatagramDestination_Type;

   function Create
     (host : String;
      port : Integer) return DatagramDestinationAccess_Type;

private
   procedure SendMessage
     (destination : DatagramDestination_Type;
      packet      : LogPacket_Type);

   procedure Close (destination : in out DatagramDestination_Type);

   procedure SendRecord
     (Destination : DatagramDestination_Type;
      Packet      : BinaryPacket_Type);

end logging.client;
