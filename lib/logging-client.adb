with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Streams;              use Ada.Streams;

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

   function Image (packet : LogPacket_Type) return String is
      destline : constant String :=
        GNAT.Time_Stamp.Current_Time &
        " " &
        Get (packet.source) &
        "> " &
        packet.class &
        "> " &
        Image (packet.level) &
        " " &
        packet.message (1 .. packet.MessageLen);
   begin
      return destline;
   end Image;

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
      pkt.source := Current_Source;
      pkt.level  := level;
      Ada.Strings.Fixed.Move (class, pkt.class, Ada.Strings.Right);
      pkt.MessageLen                    := message'Length;
      pkt.message (1 .. pkt.MessageLen) := message;
      SendMessage (Current_Destination.all, pkt);
   end log;

   procedure SendMessage
     (destination : StdOutDestination_Type;
      packet      : LogPacket_Type)
   is
   begin
      Put_Line (Image (packet));
   end SendMessage;

   function Create (name : String) return Destination_Access_Type is
      txtdest : Destination_Access_Type := new TextFileDestination_Type;
      txtfile : Ada.Text_IO.File_Type;
   begin
      Create (txtfile, Out_File, name);
      TextFileDestination_Type (txtdest.all).logfile :=
        Ada.Text_IO.Text_Streams.Stream (txtfile);
      return txtdest;
   end Create;

   procedure SendMessage
     (destination : TextFileDestination_Type;
      packet      : LogPacket_Type)
   is
      towrite    : String := Image (packet) & ASCII.LF;
      towritemem : Ada.Streams
        .Stream_Element_Array
      (1 .. Stream_Element_Offset (towrite'Length));
      for towritemem'Address use towrite'Address;
   begin
      Ada.Streams.Write (destination.logfile.all, towritemem);
   end SendMessage;

begin
   SetDestination (new StdOutDestination_Type);
end logging.client;
