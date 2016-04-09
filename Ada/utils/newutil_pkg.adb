with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Streams.Stream_IO;
with Ada.Directories;
with GNAT.Regpat;
with GNAT.Strings;
with GNAT.Directory_Operations;

with GNATCOLL.JSON;

with newutil_cli;
package body newutil_pkg is

   projectroot   : Unbounded_String := Null_Unbounded_String;
   currentconfig : Unbounded_String := To_Unbounded_String (defaultconfig);
   configobj     : GNATCOLL.JSON.JSON_Value;

   procedure show_config is
   begin
      Put_Line (To_String (currentconfig));
   end show_config;

   buildtemplates : Boolean := False;

   procedure Handler
     (Name  : in GNATCOLL.JSON.UTF8_String;
      Value : in GNATCOLL.JSON.JSON_Value)
   is
      use GNATCOLL.JSON;

   begin
      case Kind (Val => Value) is
         when JSON_Null_Type =>
            Put_Line (Name & "(null):null");
         when JSON_Boolean_Type =>
            Put_Line (Name & "(boolean):" & Boolean'Image (Get (Value)));
         when JSON_Int_Type =>
            Put_Line (Name & "(integer):" & Integer'Image (Get (Value)));
         when JSON_Float_Type =>
            Put_Line (Name & "(float):" & Float'Image (Get (Value)));
         when JSON_String_Type =>
            if Name = "templatedir" then
               templatedir := GNATCOLL.JSON.Get (Value);
            elsif buildtemplates then
               numtemplates                   := numtemplates + 1;
               templates (numtemplates)       := To_Unbounded_String (Name);
               template_values (numtemplates) := Get (Value);
               if newutil_cli.verbose
               then
                  Put_Line ("Found another template file");
               end if ;
            end if;
            if newutil_cli.verbose
            then
                Put_Line (Name & "(string):" & Get (Value));
            end if ;
         when JSON_Array_Type =>
            if Name = "templates" then
               declare
                  A_JSON_Array : constant JSON_Array := Get (Val => Value);
                  A_JSON_Value : JSON_Value;
                  Array_Length : constant Natural    := Length (A_JSON_Array);
               begin
                  Put (Name & "(array):[");
                  for J in 1 .. Array_Length loop
                     A_JSON_Value := Get (Arr => A_JSON_Array, Index => J);

                     Put (To_String (Get (A_JSON_Value)));

                     if J < Array_Length then
                        Put (", ");
                     end if;
                  end loop;
                  Put ("]");
                  New_Line;
               end;
            end if;
         when JSON_Object_Type =>
            Put_Line (Name & "(object):");
            buildtemplates := True;
            Map_JSON_Object (Val => Value, CB => Handler'Access);
            buildtemplates := False;
      end case;
      --  Decide output depending on the kind of JSON field we're dealing with.
      --  Note that if we get a JSON_Object_Type, then we recursively call
      --  Map_JSON_Object again, which in turn calls this Handler procedure.
   end Handler;

   procedure ParseConfig is
      use type GNAT.Strings.String_Access;
   begin
      configobj :=
        GNATCOLL.JSON.Read (To_String (currentconfig), Filename => "");
      GNATCOLL.JSON.Map_JSON_Object (Val => configobj, CB => Handler'Access);
      if newutil_cli.projectroot /= null
        and then newutil_cli.projectroot.all'Length = 0
      then
         Put_Line ("Project Root not specified. Use -R to provide the root");
         raise Program_Error;
      end if;

      if not Ada.Directories.Exists (newutil_cli.projectroot.all) then
         Put_Line (newutil_cli.projectroot.all & " does not exist");
         raise Program_Error;
      end if;

      projectroot :=
        To_Unbounded_String
          (Ada.Directories.Full_Name (newutil_cli.projectroot.all) &
           GNAT.Directory_Operations.Dir_Separator);
      if newutil_cli.verbose then
         Put ("Project Root: ");
         Put_Line (To_String (projectroot));
      end if;
   end ParseConfig;

   procedure load_config (filename : String) is

      filesize : Natural := Natural (Ada.Directories.Size (filename));
      use Ada.Streams;
      file   : Ada.Streams.Stream_IO.File_Type;
      stream : Ada.Streams.Stream_IO.Stream_Access;
      buffer : Ada.Streams
        .Stream_Element_Array
      (1 .. Ada.Streams.Stream_Element_Offset (filesize));
      bufferlen    : Ada.Streams.Stream_Element_Offset;
      filecontents : String (1 .. filesize);
      for filecontents'Address use buffer'Address;
   begin
      Ada.Streams.Stream_IO.Open
        (file,
         Ada.Streams.Stream_IO.In_File,
         filename);
      stream := Ada.Streams.Stream_IO.Stream (file);
      stream.Read (buffer, bufferlen);
      Ada.Streams.Stream_IO.Close (file);
      pragma Assert
        (Natural (bufferlen) = filesize,
         "entire file was not read");
      currentconfig := To_Unbounded_String (filecontents);
      ParseConfig;
   end load_config;

   linemarker_exp     : constant String             := "\[(\w+)\/\$(\w*)\]";
   linemarker_matcher : GNAT.Regpat.Pattern_Matcher :=
     GNAT.Regpat.Compile (linemarker_exp);

   procedure process_file (filename : String) is
      file    : Ada.Text_IO.File_Type;
      line    : String (1 .. 1024);
      linelen : Natural;
      linenum : Integer := 0;
      Matches : GNAT.Regpat.Match_Array (0 .. 2);
      use GNAT.Regpat;
   begin
      Ada.Text_IO.Open (file, Ada.Text_IO.In_File, filename);
      while not Ada.Text_IO.End_Of_File (file) loop
         Ada.Text_IO.Get_Line (file, line, linelen);
         linenum := linenum + 1;
         GNAT.Regpat.Match (linemarker_matcher, line (1 .. linelen), Matches);
         if newutil_cli.Verbose and then
            Matches (0) /= GNAT.Regpat.No_Match then
            Put (linenum);
            Put (" : ");
            Put_Line (line (1 .. linelen));
            Put ("Will Subsitute ");
            Put (line (Matches (1).First .. Matches (1).Last));
            Put (" by PROGNAME");
            Put (line (Matches (2).First .. Matches (2).Last));
            New_Line;
         end if;
      end loop;
      Ada.Text_IO.Close (file);
   end process_file;

   procedure process_file
     (filename       : String;
      outputfilename : String;
      progname       : String)
   is
      file, ofile : Ada.Text_IO.File_Type;
      line        : String (1 .. 1024);
      linelen     : Natural;
      linenum     : Integer := 0;
      Matches     : GNAT.Regpat.Match_Array (0 .. 2);

      startsearch : Integer;
      startsubst  : Integer;
      use GNAT.Regpat;
   begin
      if Ada.Directories.Exists (outputfilename) then
         Put (outputfilename);
         Put (" already exists.");
         if newutil_cli.overwrite then
            Put_Line (" Will overwrite.");
         else
            Put_Line (" Will not overwrite. Use -O to overwrite.");
            return;
         end if;
      end if;
      Ada.Text_IO.Open
        (file,
         Ada.Text_IO.In_File,
         To_String (projectroot) & filename);
      Ada.Text_IO.Create (ofile, Ada.Text_IO.Out_File, outputfilename);
      while not Ada.Text_IO.End_Of_File (file) loop
         Ada.Text_IO.Get_Line (file, line, linelen);
         linenum := linenum + 1;

         GNAT.Regpat.Match (linemarker_matcher, line (1 .. linelen), Matches);
         if Matches (0) = GNAT.Regpat.No_Match then
            Ada.Text_IO.Put_Line (ofile, line (1 .. linelen));
         else
            if newutil_cli.verbose
            then
               Put (linenum);
               Put (" : ");
               Put_Line (line (1 .. linelen));
               Put ("Will Subsitute ");
               Put (line (Matches (1).First .. Matches (1).Last));
               Put (" by PROGNAME");
               Put (line (Matches (2).First .. Matches (2).Last));
               New_Line;
            end if ;
            startsearch := 1;
            while startsearch < Matches (1).First loop
               startsubst :=
                 Ada.Strings.Fixed.Index
                   (line (startsearch .. Matches (1).First - 1),
                    line (Matches (1).First .. Matches (1).Last),
                    startsearch);
               if startsubst < startsearch then
                  Ada.Text_IO.Put_Line (ofile, line (startsearch .. linelen));
                  exit;
               end if;
               Ada.Text_IO.Put (ofile, line (startsearch .. startsubst - 1));
               Ada.Text_IO.Put (ofile, progname);
               Ada.Text_IO.Put
                 (ofile,
                  line (Matches (2).First .. Matches (2).Last));
               startsearch :=
                 startsubst + Matches (1).Last - Matches (1).First + 1;
            end loop;
         end if;
      end loop;
      Ada.Text_IO.Close (file);
      Ada.Text_IO.Close (ofile);
   end process_file;
end newutil_pkg;
