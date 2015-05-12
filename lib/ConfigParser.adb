with Ada.Strings.Unbounded.Equal_Case_Insensitive;
with Ada.Strings.Unbounded.Less_Case_Insensitive;
with Ada.Strings.Maps; use Ada.Strings.Maps;
with ada.strings.maps.constants; use ada.strings.maps.constants ;

with Ada.Text_IO; use Ada.Text_IO;

with gnat.spitbol.patterns ; use gnat.spitbol.patterns ;


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
   whitespace : gnat.spitbol.patterns.pattern := gnat.spitbol.patterns.nspan( " " & ascii.ht ) ;

   found_identifier : gnat.spitbol.patterns.VString_Var ;
   found_letter : gnat.spitbol.patterns.vstring_var ;

   letter : gnat.spitbol.patterns.pattern := gnat.spitbol.patterns.any(Ada.Strings.Maps.Constants.Letter_Set) * found_letter ;
   Identifier : gnat.spitbol.patterns.pattern := (letter & gnat.spitbol.patterns.span(ada.strings.maps.constants.Alphanumeric_Set)) * found_identifier ;

   found_value : gnat.spitbol.patterns.VString_Var ;
   values : gnat.spitbol.patterns.pattern := gnat.spitbol.patterns.Rest * found_value ;

   equal : gnat.spitbol.patterns.pattern ;

   found_section : gnat.spitbol.patterns.vstring_var ;
   section : gnat.spitbol.patterns.pattern :=
     "[" & Identifier * found_section & "]" ;
   option : gnat.spitbol.patterns.pattern :=
     Identifier & whitespace & "=" & whitespace & values ;

   procedure Read_File (filename : String; config : in out Config_Type) is
      cfgfile : ada.text_io.file_type ;
      textline : string(1..132) ;
      textlinelen : natural ;
   begin
      gnat.spitbol.patterns.Anchored_Mode := true ;
      ada.text_io.open(cfgfile,in_file,filename) ;
      while not end_of_file(cfgfile)
      loop
         ada.text_io.get_line(cfgfile,textline,textlinelen) ;
         if gnat.spitbol.patterns.match(textline(1..textlinelen) , section )
         then
            put("Section "); put_line( gnat.spitbol.s(found_section));
            if Has_Section(config,gnat.spitbol.s(found_section))
            then
               put_line("Section already defined");
            else
               Add_Section(config,gnat.spitbol.s(found_section)) ;
            end if ;
         else
            if gnat.spitbol.patterns.match(textline(1..textlinelen),option)
            then
               put("Option :"); put(gnat.spitbol.s(found_identifier)) ;
               put(" Value :"); put_line(gnat.spitbol.s(found_value)) ;
               if Has_Option( config , gnat.spitbol.s(found_section) , gnat.spitbol.s(found_identifier))
               then
                  put("Option "); put(gnat.spitbol.s(found_identifier)) ; put_line(" already defined") ;
               else
                  add_option( config , gnat.spitbol.s(found_section) ,
                              gnat.spitbol.s(found_identifier) ,
                              gnat.spitbol.s(found_value)) ;
               end if ;
            end if ;
         end if ;
      end loop ;
      ada.text_Io.close(cfgfile) ;
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
      sec  : Sections_Pkg.Cursor := Get (config, section);
      dict : Dictionary_Pkg.Map  := Sections_Pkg.Element (sec);
   begin
      Put ("Adding option to section ");
      New_Line;
      Dictionary_Pkg.Insert
        (dict,
         To_Unbounded_String (option),
         To_Unbounded_String (value));
      Sections_Pkg.Replace_Element (Sections_Pkg.Map (config), sec, dict);
      Put ("No of options ");
      Put (Integer'Image (Integer (Dictionary_Pkg.Length (dict))));
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
      sec  : Sections_Pkg.Cursor := Get (config, section);
      dict : Dictionary_Pkg.Map  := Sections_Pkg.Element (sec);
   begin
      if Has_Option (config, section, option) then
         Dictionary_Pkg.Delete (dict, To_Unbounded_String (option));
         Sections_Pkg.Replace_Element (Sections_Pkg.Map (config), sec, dict);
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
