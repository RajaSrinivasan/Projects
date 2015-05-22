with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;

package logging.client is

   procedure SetDestination (destination : Destination_Access_Type);

   procedure SetSource (name : String);
   procedure SetFilter (max : message_level_type);
   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class);

end logging.client;
