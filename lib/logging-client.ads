package logging.client is

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

   procedure SetDestination (destination : Destination_Access_Type);

   procedure SetSource (name : String);
   procedure SetFilter (max : message_level_type);
   procedure log
     (level   : message_level_type;
      message : String;
      class   : String := Default_Message_Class);

private
   procedure SendMessage
     (destination : StdOutDestination_Type;
      packet      : LogPacket_Type);
end logging.client;
