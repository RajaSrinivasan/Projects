with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Indefinite_Ordered_Sets;

package ConfigParser is

   package Dictionary_Pkg is new Ada.Containers.Indefinite_Ordered_Maps
     (Key_Type     => Ada.Strings.Unbounded.Unbounded_String,
      Element_Type => Ada.Strings.Unbounded.Unbounded_String);

   package Sections_Pkg is new Ada.Containers.Indefinite_Ordered_Maps
     (Key_Type     => Ada.Strings.Unbounded.Unbounded_String,
      Element_Type => Dictionary_Pkg.Map,
      "="          => Dictionary_Pkg."=");

   type Config_Type is new Sections_Pkg.Map with null record;

   function Create return Config_Type;
   procedure Read_File (filename : String; config : in out Config_Type);
   procedure Write
     (filename                : String;
      config                  : Config_Type;
      space_around_delimiters : Boolean := True);

   procedure Add_Section (config : in out Config_Type; section : String);
   procedure Remove_Section (config : in out Config_Type; section : String);
   function Has_Section
     (config  : Config_Type;
      section : String) return Boolean;
   function Get
     (config  : Config_Type;
      section : String) return Dictionary_Pkg.Map;

   procedure Add_Option
     (config  : in out Config_Type;
      section :        String;
      option  :        String;
      value   :        String);

   function Has_Option
     (config  : Config_Type;
      section : String;
      option  : String) return Boolean;

   procedure Remove_Option
     (config  : in out Config_Type;
      section :        String;
      option  :        String);

   function Get
     (config  : Config_Type;
      section : String;
      option  : String) return String;

end ConfigParser;
