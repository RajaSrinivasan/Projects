with System.Storage_Elements ; use System.Storage_Elements ;
with Ada.Text_Io; use Ada.Text_Io ;
with ihbr ; use ihbr ;

with mcu.tms320 ;
with mcu.msc1210 ;

package body mcu is

   function Create( name : string ;
                    mcutype : string ) return Controller_Type'Class is
   begin
      if mcutype = mcu.tms320.mcutype_f2810
      then
         return mcu.tms320.Create( name ) ;
      elsif mcutype = mcu.msc1210.mcutype_msc1210
      then
         return mcu.msc1210.Create( name ) ;
      end if ;

      raise Program_Error ;
   end Create ;

   function Create( name : unbounded_string ;
                    mcutype : unbounded_string ) return Controller_Type'Class is
   begin
      return Create( to_string(name) , to_string(mcutype) ) ;
   end Create ;

   procedure Initialize( controller : in out Controller_TYpe'Class ;
                         name : string ) is
   begin
      controller.name := to_unbounded_string(name) ;
   end Initialize ;


   procedure LoadHexFile( controller : in out Controller_Type'Class ;
                      hexfilename : string ) is
      use System.Storage_Elements ;
      hexfile : ihbr.File_Type ;
      hexrec : ihbr.Ihbr_Binary_Record_Type ;
   begin
      ihbr.Open( hexfilename , hexfile , WordLength(Controller) );
      while not ihbr.End_Of_File( hexfile )
      loop
         ihbr.GetNext( hexfile , hexrec ) ;
         mcu.Set( Controller , hexrec ) ;
       end loop ;
       ihbr.Close( hexfile ) ;
   end LoadHexFile ;

   procedure GenerateHexFile( controller : Controller_Type'Class ;
                              hexfilename : string ;
                              blocklen : integer ) is
      hexfileout : ihbr.File_Type ;
      hexrec : ihbr.Ihbr_Binary_Record_Type ;
      linecount : Integer := 0 ;
      romaddress : Unsigned_32 := 0 ;
      CRC : unsigned_16 := 0 ;
      end_of_memory : boolean := false ;
   begin
      hexfileout := ihbr.Create( hexfilename );
      while not End_Of_Memory
      loop
         Get( controller , romaddress , blocklen , end_of_memory , hexrec ) ;
         ihbr.PutNext( hexfileout , hexrec ) ;
      end loop ;
      ihbr.Close( hexfileout ) ;
   end GenerateHexFile ;



   function WordLength( controller : Controller_Type )
                       return Integer is
   begin
      return 1 ;
   end WordLength ;

   function InSector( sector : flash_ptr_type ;
                      address : unsigned_32 ) return boolean is
   begin
      if address >= sector.start and
         address <  sector.start + unsigned_32(sector.length)
      then
         return true ;
      end if ;
      return false ;
   end InSector ;
   function Insector( sectors : sectors_ptr_type ;
                      address : unsigned_32 ) return integer is
   begin
      for sector in sectors'Range
      loop
         if InSector( sectors(sector) , address )
         then
            return sector ;
         end if ;
      end loop ;
      return sectors'first-1 ;
   end InSector ;

   procedure Show( controller : access Controller_Type'Class ) is
   begin
      put("Controller : ");
      put_line( to_string(Controller.name) ) ;
      Show( controller.all ) ;
   end Show ;

end mcu ;
