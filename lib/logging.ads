with Calendar;
with System.Storage_Elements;
with Interfaces.C;
with Interfaces.C.Strings;

package logging is

   subtype message_level_type is Natural;

   CRITICAL      : constant message_level_type := 10;
   ERROR         : constant message_level_type := 20;
   WARNING       : constant message_level_type := 30;
   INFORMATIONAL : constant message_level_type := 40;
   function Image (level : message_level_type) return String;

   type Source_type is new Natural range 1 .. 128;
   procedure RegisterAll (filename : String);
   function Get (source : Source_type) return String;
   function Get (name : String) return Source_type;

   subtype Message_Class_Type is String (1 .. 6);
   Default_Message_Class : Message_Class_Type := (others => '.');

   MAX_MESSAGE_LENGTH : constant := 132;
   type LogPacketHdr_Type is tagged record
      source : Source_type;
   end record;

   type LogPacket_Type is new LogPacketHdr_Type with record
      level      : message_level_type;
      class      : Message_Class_Type;
      MessageLen : Natural;
      message    : String (1 .. MAX_MESSAGE_LENGTH);
   end record;

   type timeval_type is record
      tv_sec  : Interfaces.C.long;
      tv_usec : Interfaces.C.long;
   end record;
   pragma Convention (C, timeval_type);
   procedure GetClock (tv : not null access timeval_type);
   pragma Import (C, GetClock, "GetClock");

   function Printable
     (tv : not null access timeval_type)
      return Interfaces.C.Strings.char_array_access;
   pragma Import (C, Printable, "Printable");

   MAX_BINARY_RECORD_LENGTH : constant := 256;
   type BinaryPacket_Type is new LogPacketHdr_Type with record
      timestamp : timeval_type;
      RecordLen : Integer;
      data      : System.Storage_Elements
        .Storage_Array
      (1 .. MAX_BINARY_RECORD_LENGTH);
   end record;

   procedure SelfTest;
end logging;
