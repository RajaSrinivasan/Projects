with Calendar;
with System.Storage_Elements;
with Interfaces.C;
with Interfaces.C.Strings;

with Ada.Calendar;
with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Streams;              use Ada.Streams;

package logging is

   type Source_type is new Natural range 1 .. 128;
   -- Register a single source.
   -- Simplest usage is to register with just a name
   procedure Register( source : String ;
                       id : Source_Type := Source_Type'Last) ;
   -- Register a set of sources from a simple text file
   -- Useful for a group of programs working together
   procedure RegisterAll (filename : String) ;
   function Get (source : Source_type) return String;
   function Get (name : String) return Source_type;


   subtype message_level_type is Natural range 1..128 ;

   CRITICAL      : constant message_level_type := 10 ;
   ERROR         : constant message_level_type := 20 ;
   WARNING       : constant message_level_type := 30 ;
   INFORMATIONAL : constant message_level_type := 40 ;
   function Image (level : message_level_type) return String;

   -- Setup a threshold for message levels
   -- Any messges of a level >= specified will be filtered out
   -- e.g. Filter( WARNING ) ; will not process any messages - WARNING, INFORMATIONAL etc
   procedure Filter( level : message_level_type := INFORMATIONAL ) ;

   -- Within a program, different classes of messages
   -- may be generated. different tasks or different facilities
   -- may use their own name
   subtype Message_Class_Type is String (1 .. 6);
   Default_Message_Class : Message_Class_Type := (others => '.');

   -- Messages of this class will be filtered out
   procedure Filter( class : String ) ;


   type Destination_Type is abstract tagged null record ;
   procedure Set( dest : in out destination_type ) ;

   -- Simplest form of message
   procedure Log( Message : String ;
                  level : message_level_type := CRITICAL ;
                  class : message_class_type := Default_Message_Class ) ;

--     MAX_MESSAGE_LENGTH : constant := 132;
--     type LogPacketHdr_Type is record
--        source : Source_type;
--     end record;

--     type LogPacket_Type is record
--        hdr        : LogPacketHdr_Type;
--        level      : message_level_type;
--        class      : Message_Class_Type;
--        MessageLen : Natural;
--        message    : String (1 .. MAX_MESSAGE_LENGTH);
--     end record;
--     function Time_Stamp return String;
--     function Image (packet : LogPacket_Type) return String;
--
--     subtype RecordName_Type is String (1 .. 12);
--     MAX_BINARY_RECORD_LENGTH : constant := 256;
--     type BinaryPacket_Type is record
--        hdr       : LogPacketHdr_Type;
--        Name      : RecordName_Type;
--        timestamp : Ada.Calendar.Time;
--        RecordLen : Short_Integer;
--        data      : System.Storage_Elements
--          .Storage_Array
--        (1 .. MAX_BINARY_RECORD_LENGTH);
--     end record;
--
--     type Destination_Type is abstract tagged record
--        null;
--     end record;

--     procedure SendMessage
--       (destination : Destination_Type;
--        packet      : LogPacket_Type) is abstract;
--
--     procedure Close (destination : in out Destination_Type) is abstract;
--
--     procedure SendRecord
--       (Destination : Destination_Type;
--        Packet      : BinaryPacket_Type) is abstract;
--
--     type Destination_Access_Type is access all Destination_Type'Class;
--     procedure SetDestination (destination : Destination_Access_Type);
--
--     type StdOutDestination_Type is new Destination_Type with record
--        null;
--     end record;
--
--     type TextFileDestination_Type is new Destination_Type with record
--        logfile : access Ada.Text_IO.File_Type;
--     end record;
--     type TextFileDestinationAccess_Type is access all TextFileDestination_Type;
--
--     function Create (name : String) return TextFileDestinationAccess_Type;
--     procedure Close (dest : TextFileDestinationAccess_Type);
--
--     procedure SelfTest;
--
--  private
--     procedure SendMessage
--       (destination : StdOutDestination_Type;
--        packet      : LogPacket_Type);
--     procedure Close (destination : in out StdOutDestination_Type);
--
--     procedure SendMessage
--       (destination : TextFileDestination_Type;
--        packet      : LogPacket_Type);
--
--     procedure Close (destination : in out TextFileDestination_Type);
--
--     procedure SendRecord
--       (Destination : StdOutDestination_Type;
--        Packet      : BinaryPacket_Type);
--     procedure SendRecord
--       (Destination : TextFileDestination_Type;
--        Packet      : BinaryPacket_Type);
--
--     Current_Destination : Destination_Access_Type;
--     Current_Source      : Source_type := Source_type'First;
end logging;
