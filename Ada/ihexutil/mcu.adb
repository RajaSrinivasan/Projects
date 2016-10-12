with Ada.Text_Io; use Ada.Text_Io ;
with mcu.tms320 ;
package body mcu is
   function Create( name : string ;
                    mcutype : string ) return Controller_Type'Class is
   begin
      if mcutype = "f2810"
      then
         return mcu.tms320.Create( name ) ;
      end if ;

      raise Program_Error ;
   end Create ;
   procedure Initialize( controller : in out Controller_TYpe'Class ;
                         name : string ) is
   begin
      controller.name := to_unbounded_string(name) ;
   end Initialize ;

   function InSector( sector : sector_ptr_type ;
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
