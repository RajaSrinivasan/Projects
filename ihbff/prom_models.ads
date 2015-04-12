with Interfaces;

with Ihbr;
with Prom;

package Prom_Models is
   type context_type is record
      called    : Integer := 0;
      blocksize : Integer := 16;
      nextbyte  : Integer := 0;
   end record;
   package ByteProm_pkg is new Prom (Interfaces.Unsigned_8, context_type);
   procedure Converter
     (module  :        ByteProm_pkg.module_type;
      binrec  :    out Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type);

   package WordProm_pkg is new Prom (Interfaces.Unsigned_16, context_type);
end Prom_Models;
