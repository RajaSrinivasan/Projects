with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Time_Stamp;

package body logging.client is

   Current_Destination : Destination_Access_Type;

   Current_Source            : Source_type        := Source_type'First;
   Current_Max_Message_Level : message_level_type := message_level_type'Last;

   procedure SetDestination (destination : Destination_Access_Type) is
   begin
      Current_Destination := destination;
   end SetDestination;

   procedure SetSource (name : String) is
   begin
      Current_Source := Get (name);
   end SetSource;

   procedure SetFilter (max : message_level_type) is
   begin
      Current_Max_Message_Level := max;
   end SetFilter;

   ---------
   -- log --
   ---------

   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class)
   is
      pkt : LogPacket_Type;
   begin
      if level > Current_Max_Message_Level then
         return;
      end if;
      pkt.hdr.source := Current_Source;
      pkt.level      := level;
      Ada.Strings.Fixed.Move (class, pkt.class, Ada.Strings.Right);
      pkt.MessageLen                    := message'Length;
      pkt.message (1 .. pkt.MessageLen) := message;
      SendMessage (Current_Destination.all, pkt);
   end log;

begin
   SetDestination (new StdOutDestination_Type);
end logging.client;
