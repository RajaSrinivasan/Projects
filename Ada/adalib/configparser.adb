with Ada.Strings.Unbounded.Equal_Case_Insensitive;
with Ada.Strings.Unbounded.Less_Case_Insensitive;
with Ada.Strings.Maps;           use Ada.Strings.Maps;
with Ada.Strings.Maps.Constants; use Ada.Strings.Maps.Constants;

with Ada.Text_IO; use Ada.Text_IO;

with GNAT.Spitbol.Patterns; use GNAT.Spitbol.Patterns;

package body ConfigParser is

   ------------
   -- Create --
   ------------

   function Create return Config_Type is
      newconfig : Config_Type;
   begin
      return newconfig;
   end Create;

   ---------------
   -- Read_File --
   ---------------
   whitespace : GNAT.Spitbol.Patterns.Pattern :=
     GNAT.Spitbol.Patterns.NSpan (" " & ASCII.HT);

   found_identifier : GNAT.Spitbol.Patterns.VString_Var;
   found_letter     : GNAT.Spitbol.Patterns.VString_Var;

   letter : GNAT.Spitbol.Patterns.Pattern :=
     GNAT.Spitbol.Patterns.Any (Ada.Strings.Maps.Constants.Letter_Set) *
     found_letter;
   Identifier : GNAT.Spitbol.Patterns.Pattern :=
     (letter &
      GNAT.Spitbol.Patterns.Span
        (Ada.Strings.Maps.Constants.Alphanumeric_Set)) *
     found_identifier;

   found_value : GNAT.Spitbol.Patterns.VString_Var;
   values      : GNAT.Spitbol.Patterns.Pattern :=
     GNAT.Spitbol.Patterns.Rest * found_value;

   equal : GNAT.Spitbol.Patterns.Pattern;

   found_section : GNAT.Spitbol.Patterns.VString_Var;
   section       : GNAT.Spitbol.Patterns.Pattern :=
     "[" & Identifier * found_section & "]";
   option : GNAT.Spitbol.Patterns.Pattern :=
     Identifier & whitespace & "=" & whitespace & values;

   escapedchar : GNAT.Spitbol.Patterns.VString_Var := GNAT.Spitbol.V ("\#");
   escaped     : GNAT.Spitbol.Patterns.Pattern     := +escapedchar;

   procedure Read_File (filename : String; config : in out Config_Type) is
      cfgfile     : Ada.Text_IO.File_Type;
      textline    : String (1 .. 132);
      textlinelen : Natural;

      commentmatch : GNAT.Spitbol.Patterns.Match_Result_Var;
      templine     : GNAT.Spitbol.Patterns.VString_Var;

      procedure StripComments is
         chptr : Integer := 1;
      begin
         while chptr <= textlinelen loop
            case textline (chptr) is
               when '"' =>
                  while chptr <= textlinelen loop
                     if textline (chptr) = '"' then
                        exit;
                     end if;
                  end loop;
               when '#' =>
                  Put_Line ("Stripping Comments");
                  Put_Line (textline (chptr .. textlinelen));
                  textlinelen := chptr - 1;
                  exit;
               when '\' =>
                  if chptr = textlinelen then
                     exit;
                  end if;
                  chptr := chptr + 2;
               when others =>
                  chptr := chptr + 1;
            end case;
         end loop;
      end StripComments;

   begin

      GNAT.Spitbol.Patterns.Anchored_Mode := True;
      Ada.Text_IO.Open (cfgfile, In_File, filename);
      while not End_Of_File (cfgfile) loop
         Ada.Text_IO.Get_Line (cfgfile, textline, textlinelen);
         StripComments;
         if textlinelen > 0 then
            templine := GNAT.Spitbol.V (textline (1 .. textlinelen));

            if GNAT.Spitbol.Patterns.Match (templine, section) then
               Put ("Section ");
               Put_Line (GNAT.Spitbol.S (found_section));
               if Has_Section (config, GNAT.Spitbol.S (found_section)) then
                  Put_Line ("Section already defined");
               else
                  Add_Section (config, GNAT.Spitbol.S (found_section));
               end if;
            else
               if GNAT.Spitbol.Patterns.Match
                   (textline (1 .. textlinelen),
                    option)
               then
                  Put ("Option :");
                  Put (GNAT.Spitbol.S (found_identifier));
                  Put (" Value :");
                  Put_Line (GNAT.Spitbol.S (found_value));
                  GNAT.Spitbol.Patterns.Match (found_value, escaped, "#");
                  if Has_Option
                      (config,
                       GNAT.Spitbol.S (found_section),
                       GNAT.Spitbol.S (found_identifier))
                  then
                     Put ("Option ");
                     Put (GNAT.Spitbol.S (found_identifier));
                     Put_Line (" already defined");
                  else
                     Add_Option
                       (config,
                        GNAT.Spitbol.S (found_section),
                        GNAT.Spitbol.S (found_identifier),
                        GNAT.Spitbol.S (found_value));
                  end if;
               end if;
            end if;
         end if;
      end loop;
      Ada.Text_IO.Close (cfgfile);
   end Read_File;

   -----------
   -- Write --
   -----------

   procedure Write
     (filename                : String;
      config                  : Config_Type;
      space_around_delimiters : Boolean := True)
   is
      configfile : Ada.Text_IO.File_Type;

      procedure Write (cursor : Dictionary_Pkg.Cursor) is
         key   : Unbounded_String := Dictionary_Pkg.Key (cursor);
         value : Unbounded_String := Dictionary_Pkg.Element (cursor);
      begin
         Put (configfile, To_String (key));
         if space_around_delimiters then
            Put (configfile, " ");
         end if;
         Put (configfile, "=");
         if space_around_delimiters then
            Put (configfile, " ");
         end if;
         Put_Line (configfile, To_String (value));
      end Write;

      procedure Write (cursor : Sections_Pkg.Cursor) is
         dict : Dictionary_Pkg.Map := Sections_Pkg.Element (cursor);
      begin
         Put (configfile, "[");
         Put (configfile, To_String (Sections_Pkg.Key (cursor)));
         Put_Line (configfile, "]");

         Put ("No of options ");
         Put (Integer'Image (Integer (Dictionary_Pkg.Length (dict))));
         New_Line;
         Dictionary_Pkg.Iterate (dict, Write'Access);
      end Write;
   begin
      Create (configfile, Out_File, filename);
      Sections_Pkg.Iterate (Sections_Pkg.Map (config), Write'Access);
      Close (configfile);
   end Write;

   -----------------
   -- Add_Section --
   -----------------

   procedure Add_Section (config : in out Config_Type; section : String) is
      unbname : Unbounded_String   := To_Unbounded_String (section);
      dict    : Dictionary_Pkg.Map := Dictionary_Pkg.Empty_Map;
   begin
      if Has_Section (config, section) then
         return;
      end if;
      Sections_Pkg.Insert (Sections_Pkg.Map (config), unbname, dict);
   end Add_Section;

   --------------------
   -- Remove_Section --
   --------------------

   procedure Remove_Section (config : in out Config_Type; section : String) is
   begin
      if not Has_Section (config, section) then
         return;
      end if;
      Sections_Pkg.Delete
        (Sections_Pkg.Map (config),
         To_Unbounded_String (section));
   end Remove_Section;

   -----------------
   -- Has_Section --
   -----------------

   function Has_Section
     (config  : Config_Type;
      section : String) return Boolean
   is
   begin
      return Sections_Pkg.Has_Element
          (Sections_Pkg.Find
             (Sections_Pkg.Map (config),
              To_Unbounded_String (section)));
   end Has_Section;

   -------------
   -- Section --
   -------------
   function Get
     (config  : Config_Type;
      section : String) return Sections_Pkg.Cursor
   is
   begin
      return Sections_Pkg.Find
          (Sections_Pkg.Map (config),
           To_Unbounded_String (section));
   end Get;

   function Get
     (config  : Config_Type;
      section : String) return Dictionary_Pkg.Map
   is

   begin
      return Sections_Pkg.Element
          (Sections_Pkg.Find
             (Sections_Pkg.Map (config),
              To_Unbounded_String (section)));
   end Get;

   ----------------
   -- Add_Option --
   ----------------
   procedure Add_Option
     (config  : in out Config_Type;
      section :        String;
      option  :        String;
      value   :        String)
   is
      sec     : Sections_Pkg.Cursor         := Get (config, section);
      dictref : Sections_Pkg.Reference_Type :=
        Sections_Pkg.Reference (Sections_Pkg.Map (config), sec);
   begin
      Put ("Adding option to section ");
      New_Line;
      Dictionary_Pkg.Insert
        (dictref,
         To_Unbounded_String (option),
         To_Unbounded_String (value));
      Put ("No of options ");
      Put (Integer'Image (Integer (Dictionary_Pkg.Length (dictref))));
      New_Line;
   end Add_Option;

   function Has_Option
     (config  : Config_Type;
      section : String;
      option  : String) return Boolean
   is
      dict : Dictionary_Pkg.Map := Get (config, section);
   begin
      return Dictionary_Pkg.Contains (dict, To_Unbounded_String (option));
   end Has_Option;

   -------------------
   -- Remove_Option --
   -------------------
   procedure Remove_Option
     (config  : in out Config_Type;
      section :        String;
      option  :        String)
   is
      sec     : Sections_Pkg.Cursor         := Get (config, section);
      dictref : Sections_Pkg.Reference_Type :=
        Sections_Pkg.Reference (Sections_Pkg.Map (config), sec);
   begin
      if Has_Option (config, section, option) then
         Dictionary_Pkg.Delete (dictref, To_Unbounded_String (option));
      end if;
   end Remove_Option;

   ---------
   -- Get --
   ---------

   function Get
     (config  : Config_Type;
      section : String;
      option  : String) return String
   is
      dict : Dictionary_Pkg.Map := Get (config, section);
   begin
      return To_String
          (Dictionary_Pkg.Element (dict, To_Unbounded_String (option)));
   end Get;

end ConfigParser;
