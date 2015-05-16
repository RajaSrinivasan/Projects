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
   MAX_MESSAGE_LENGTH    : constant           := 132;
   type LogPacket_Type is record
      source     : Source_type;
      level      : message_level_type;
      class      : Message_Class_Type;
      MessageLen : Natural;
      message    : String (1 .. MAX_MESSAGE_LENGTH);
   end record;

end logging;
