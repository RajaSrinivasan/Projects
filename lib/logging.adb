with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;
with ada.strings.maps ;

with Ada.Streams;              use Ada.Streams;
with Ada.Calendar ;            use Ada.Calendar ;
with Ada.Calendar.Formatting ; use Ada.Calendar.Formatting ;

with GNAT.Time_Stamp;

package body logging is

   procedure SetDestination (destination : Destination_Access_Type) is
   begin
      Current_Destination := destination;
   end SetDestination;

   package Sources_Pkg is new Ada.Containers.Vectors
     (Source_type,
      Unbounded_String);
   registered_sources : Sources_Pkg.Vector;

   function Time_Stamp return String is
      ts : unbounded_string
        := To_Unbounded_String( gnat.Time_Stamp.Current_Time ) ;
      pos : natural := 0 ;
      removeset : ada.strings.maps.Character_Set ;
   begin
      removeset := ada.strings.maps.To_Set("-:. ");
      loop
         pos := ada.strings.unbounded.index( ts , removeset ) ;
         if pos = 0
         then
            exit ;
         end if ;
         ada.strings.unbounded.Delete( ts , pos , pos ) ;
      end loop ;
      return to_string(ts) ;
   end Time_Stamp ;

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
         Put_Line ("Did not find source " & name);
         return Source_type'Last;
      end if;
      Put_Line("Found the source " & Name);
      return Sources_Pkg.To_Index (cursor);
   end Get;

   function Image (packet : LogPacket_Type) return String is
      destline : constant String :=
        gnat.Time_Stamp.Current_Time &
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
      txtdest.logfile := new Ada.Text_IO.File_Type ;
      Ada.Text_Io.Create (txtdest.logfile.all , Out_File, name);
      return txtdest;
   end Create;
   procedure Close(dest : TextFileDestinationAccess_Type) is
   begin
      Ada.Text_IO.Close( dest.logfile.all ) ;
   end Close ;

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
      towrite    : String := Image (packet) ;
   begin
      Ada.Text_Io.Put_Line(destination.logfile.all, towrite) ;
      Ada.Text_Io.Flush(destination.logfile.all);
   end SendMessage;

   procedure SelfTest is
   begin
      for i in 1 .. 10 loop
         put_line(Ada.Calendar.Formatting.Image(Ada.CAlendar.Clock)) ;
         delay 0.5 ;
      end loop;
   end SelfTest;

end logging;
