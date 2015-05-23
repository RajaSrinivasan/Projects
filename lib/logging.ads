with Calendar;
with System.Storage_Elements;
with Interfaces.C;
with Interfaces.C.Strings;

with Ada.Calendar ;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Streams;              use Ada.Streams;

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
   type LogPacketHdr_Type is record
      source : Source_type;
   end record;

   type LogPacket_Type is record
      hdr        : LogPacketHdr_Type;
      level      : message_level_type;
      class      : Message_Class_Type;
      MessageLen : Natural;
      message    : String (1 .. MAX_MESSAGE_LENGTH);
   end record;

   function Image (packet : LogPacket_Type) return String ;

   MAX_BINARY_RECORD_LENGTH : constant := 256;
   type BinaryPacket_Type is record
      hdr       : LogPacketHdr_Type;
      timestamp : Ada.Calendar.Time ;
      RecordLen : Integer;
      data      : System.Storage_Elements
        .Storage_Array
      (1 .. MAX_BINARY_RECORD_LENGTH);
   end record;

   type Destination_Type is abstract tagged record
      null;
   end record;

   procedure SendMessage
     (destination : Destination_Type;
      packet      : LogPacket_Type) is abstract;
   type Destination_Access_Type is access all Destination_Type'Class;

   type StdOutDestination_Type is new Destination_Type with record
      null;
   end record;

   type TextFileDestination_Type is new Destination_Type with record
      logfile : Stream_Access;
   end record;
   type TextFileDestinationAccess_Type is access all TextFileDestination_Type;

   function Create (name : String) return TextFileDestinationAccess_Type ;

   procedure SelfTest;

private
   procedure SendMessage
     (destination : StdOutDestination_Type;
      packet      : LogPacket_Type);
   procedure SendMessage
     (destination : TextFileDestination_Type;
      packet      : LogPacket_Type);

end logging;
