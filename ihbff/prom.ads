with Ihbr;
generic
   type word_type is (<>);
   type context_type is private;
package Prom is

   type cells_type is array (Positive range <>) of word_type;
   type module_type is access all cells_type;

   function Create (size : Positive) return module_type;
   procedure Erase
     (module : in out module_type;
      value  :        word_type := word_type'Last);
   procedure Set
     (module  : in out module_type;
      address :        natural ;
      value   :        word_type);
   function Get (module : module_type; address : natural) return word_type;
   type extractor_procedure is access procedure
     (module  : in out module_type;
      binrec  :        Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type);
   -- Load from intel hex binary file
   procedure Load
     (filename  :        String;
      module    :    out module_type;
      context   : in out context_type;
      extractor :        extractor_procedure);
   -- read from a binary file
   procedure Read (filename : String; module : out module_type);

   type converter_procedure is access procedure
     (module  :        module_type;
      binrec  :    out Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type);
   procedure Save
     (filename  :        String;
      module    :        module_type;
      context   : in out context_type;
      converter :        converter_procedure);
   procedure Write (filename : String; module : module_type);

end Prom;
