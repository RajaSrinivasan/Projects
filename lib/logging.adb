with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with Ada.Streams;              use Ada.Streams;
with GNAT.Time_Stamp;
package body logging is

   package Sources_Pkg is new Ada.Containers.Vectors
     (Source_type,
      Unbounded_String);
   registered_sources : Sources_Pkg.Vector;

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
   end RegisterAll;

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
         pragma Debug (Put_Line ("Did not find source " & name));
         return Source_type'Last;
      end if;
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
      Create (txtfile, Out_File, name);
      TextFileDestination_Type (txtdest.all).logfile :=
        Ada.Text_IO.Text_Streams.Stream (txtfile);
      return txtdest;
   end Create;

   procedure SendMessage
     (destination : StdOutDestination_Type;
      packet      : LogPacket_Type)
   is
   begin
      Put_Line (Image (packet));
   end SendMessage;

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

   procedure SelfTest is
      timenow : aliased timeval_type;
   begin
      for i in 1 .. 10 loop
         GetClock (timenow'Access);
         Put_Line
           (Interfaces.C.Strings.Value
              (Interfaces.C.Strings.To_Chars_Ptr
                 (Printable (timenow'Access))));
      end loop;
   end SelfTest;

end logging;
