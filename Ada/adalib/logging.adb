with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Short_Integer_Text_IO; use Ada.Short_Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Directories;

with Ada.Streams;             use Ada.Streams;
with Ada.Calendar;            use Ada.Calendar;
with Ada.Calendar.Formatting; use Ada.Calendar.Formatting;

with GNAT.Time_Stamp;

with Hex;

package body logging is

   procedure SetDestination (destination : Destination_Access_Type) is
   begin
      if Current_Destination /= null then
         Close (Current_Destination.all);
      end if;
      Current_Destination := destination;
   end SetDestination;

   package Sources_Pkg is new Ada.Containers.Vectors
     (Source_type,
      Unbounded_String);
   registered_sources : Sources_Pkg.Vector;

   function Time_Stamp return String is
      ts : Unbounded_String :=
        To_Unbounded_String (GNAT.Time_Stamp.Current_Time);
      pos       : Natural := 0;
      removeset : Ada.Strings.Maps.Character_Set;
   begin
      removeset := Ada.Strings.Maps.To_Set ("-:. ");
      loop
         pos := Ada.Strings.Unbounded.Index (ts, removeset);
         if pos = 0 then
            exit;
         end if;
         Ada.Strings.Unbounded.Delete (ts, pos, pos);
      end loop;
      return To_String (ts);
   end Time_Stamp;

   function Image (level : message_level_type) return String is
   begin
      case level is
         when CRITICAL =>
            return "[C]";
         when ERROR =>
            return "[E]";
         when WARNING =>
            return "[W]";
         when INFORMATIONAL =>
            return "[I]";
         when others =>
            return "[" & message_level_type'Image (level) & "]";
      end case;
   end Image;

   -----------------
   -- RegisterAll --
   -----------------
   procedure RegisterAll (filename : String) is
      sourcesfile   : Ada.Text_IO.File_Type;
      sourceline    : String (1 .. 32);
      sourcelinelen : Natural;
   begin
      Sources_Pkg.Reserve_Capacity
        (registered_sources,
         Ada.Containers.Count_Type (Source_type'Last));
      Open (sourcesfile, In_File, filename);
      while not End_Of_File (sourcesfile) loop
         Get_Line (sourcesfile, sourceline, sourcelinelen);
         pragma Debug
           (Put_Line ("Registering " & sourceline (1 .. sourcelinelen)));
         Sources_Pkg.Append
           (registered_sources,
            To_Unbounded_String (sourceline (1 .. sourcelinelen)));
      end loop;
      Close (sourcesfile);
   end RegisterAll ;
   
   procedure Register( Source_Name : String ) is
   begin
      Sources_Pkg.Append
	(registered_sources,
	 To_Unbounded_String (Source_Name));
   end Register ;

   ---------
   -- Get --
   ---------

   function Get (source : Source_type) return String is
      regsource : Unbounded_String;
   begin
      regsource := Sources_Pkg.Element (registered_sources, source);
      return To_String (regsource);
   exception
      when others =>
         return "Unknown";
   end Get;

   ---------
   -- Get --
   ---------

   function Get (name : String) return Source_type is
      use Sources_Pkg;
      cursor : Sources_Pkg.Cursor;
   begin
      cursor :=
        Sources_Pkg.Find (registered_sources, To_Unbounded_String (name));
      if cursor = Sources_Pkg.No_Element then
         Put_Line ("Did not find source " & name);
         return Source_type'Last;
      end if;
      Put_Line ("Found the source " & name);
      return Sources_Pkg.To_Index (cursor);
   end Get;

   function Image (packet : LogPacket_Type) return String is
      destline : constant String :=
        GNAT.Time_Stamp.Current_Time &
        " " &
        Get (packet.hdr.source) &
        "> " &
        packet.class &
        "> " &
        Image (packet.level) &
        " " &
        packet.message (1 .. packet.MessageLen);
   begin
      return destline;
   end Image;

   function Create (name : String) return TextFileDestinationAccess_Type is
      txtdest : TextFileDestinationAccess_Type := new TextFileDestination_Type;
      txtfile : Ada.Text_IO.File_Type;
   begin
      txtdest.logfile := new Ada.Text_IO.File_Type;
      Ada.Text_IO.Create (txtdest.logfile.all, Out_File, name);
      Ada.Text_IO.Put (txtdest.logfile.all, "*********");
      Ada.Text_IO.Put (txtdest.logfile.all, Ada.Directories.Base_Name (name));
      Ada.Text_IO.Put (txtdest.logfile.all, "*********");
      Ada.Text_IO.Put (txtdest.logfile.all, "Created ");
      Ada.Text_IO.Put (txtdest.logfile.all, GNAT.Time_Stamp.Current_Time);
      Ada.Text_IO.Put_Line (txtdest.logfile.all, "*********");
      return txtdest;
   end Create;
   procedure Close (dest : TextFileDestinationAccess_Type) is
   begin
      Ada.Text_IO.Close (dest.logfile.all);
   end Close;

   procedure SendMessage
     (destination : StdOutDestination_Type;
      packet      : LogPacket_Type)
   is
   begin
      Put_Line (Image (packet));
   end SendMessage;
   procedure Close (destination : in out StdOutDestination_Type) is
   begin
      null;
   end Close;

   procedure SendMessage
     (destination : TextFileDestination_Type;
      packet      : LogPacket_Type)
   is
      towrite : String := Image (packet);
   begin
      Ada.Text_IO.Put_Line (destination.logfile.all, towrite);
      Ada.Text_IO.Flush (destination.logfile.all);
   end SendMessage;

   procedure Close (destination : in out TextFileDestination_Type) is
   begin
      Ada.Text_IO.Close (destination.logfile.all);
   end Close;

   procedure ShowRecord (File : File_Type; Packet : BinaryPacket_Type) is
   begin
      Put (File, Packet.Name);
      Put (File, " ");
      Put (File, "Length : ");
      Put (File, Packet.RecordLen);
      Put (File, Hex.Image (Packet.data'Address, Integer (Packet.RecordLen)));
      New_Line (File);
   end ShowRecord;

   procedure SendRecord
     (Destination : StdOutDestination_Type;
      Packet      : BinaryPacket_Type)
   is
   begin
      ShowRecord (Standard_Output, Packet);
   end SendRecord;

   procedure SendRecord
     (Destination : TextFileDestination_Type;
      Packet      : BinaryPacket_Type)
   is
   begin
      ShowRecord (Destination.logfile.all, Packet);
   end SendRecord;

   procedure SelfTest is
   begin
      for i in 1 .. 10 loop
         Put_Line (Ada.Calendar.Formatting.Image (Ada.Calendar.Clock));
         delay 0.5;
      end loop;
   end SelfTest;

end logging;
