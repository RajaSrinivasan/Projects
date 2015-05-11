with system.Storage_Elements ;
with Interfaces;

with Ihbr;
with Prom;

package Prom_Models is

   verbose : boolean := false ;
   Kilo    : constant := 1024 ;
   Mega    : constant := 1024 * 1024 ;

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
   procedure extractor
     (module  : in out ByteProm_pkg.module_type;
      binrec  :        Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type);
   function LoadHexFile( filename : string ;
                         PromSize : integer ;
                         erasevalue : interfaces.unsigned_8 := interfaces.unsigned_8'last )
                        return ByteProm_pkg.module_type ;
   function LoadBinFile( filename : string ;
                         PromSize : integer ;
                         erasevalue : interfaces.unsigned_8 := interfaces.unsigned_8'last )
                        return ByteProm_pkg.module_type ;
   procedure DumpModule( module : ByteProm_pkg.module_type ;
                         blocklen : integer := 16 ) ;
   procedure ComputeAndUpdateCRC( module : in out ByteProm_pkg.module_type ;
                                  computecrc16 : boolean := true ;
                                  computecrc32 : boolean := true ) ;
  -- package WordProm_pkg is new Prom (Interfaces.Unsigned_16, context_type);

end Prom_Models;
