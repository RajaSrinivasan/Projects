with Ada.Text_Io; use ADa.Text_Io ;
with Ada.Integer_Text_IO ; use Ada.Integer_Text_IO ;

package body mcu.tms320 is

   function Create( name : string ) return f2810_type is
      this : f2810_type ;
      procedure set_sector( num : integer ; name : string ; beginadr : Unsigned_32 ; length : Unsigned_16 ) is
         thissector : flash_ptr_type := new flash_type ;
      begin
         thissector.name := to_unbounded_string (name) ;
         thissector.start := beginadr ;
         thissector.length := length ;
         flash_ptr_type(thissector).ram := new bits16_memory_block_type(1..integer(length)) ;
         thissector.ram.all := (others => 16#ffff#) ;
         this.flash(num) := sector_ptr_type(thissector) ;
      end set_sector ;

   begin
      Initialize( this , name ) ;
      set_sector(1 , "SECTORA" , 16#003f_6000# , 16#1ff8# ) ;
      set_sector(2 , "SECTORB" , 16#003f_4000# , 16#2000# ) ;
      set_sector(3 , "SECTORC" , 16#003f_0000# , 16#4000# ) ;
      set_sector(4 , "SECTORD" , 16#003e_c000# , 16#4000# ) ;
      set_sector(5 , "SECTORE" , 16#003e_8000# , 16#4000# ) ;
      return this ;
   end create ;


   procedure Set( controller : f2810_type ;
                  ramaddress : Unsigned_32 ;
                  value : Unsigned_32 ) is
      sector : integer ;
   begin
      sector := InSector( controller.flash , ramaddress ) ;
      if sector in controller.flash'range
      then
         declare
            flash : flash_ptr_type := flash_ptr_type( controller.flash(sector) ) ;
         begin
            flash.ram.all( integer(ramaddress - controller.flash(sector).start) + 1) := unsigned_16(value) ;
            return ;
         end ;
      end if ;
      raise Program_Error;
   end Set ;

   function Get( controller : f2810_Type ;
                 ramaddress : Unsigned_32 )
                return Unsigned_32 is
      sector : integer ;
   begin
      sector := InSector( controller.flash , ramaddress ) ;
      if sector in controller.flash'range
      then
         declare
            flash : flash_ptr_type := flash_ptr_type( controller.flash(sector) ) ;
         begin
            return unsigned_32( flash.ram.all( integer(ramaddress - controller.flash(sector).start) + 1)) ;
         end ;
      end if ;
      raise Program_error ;
   end Get ;


   procedure Show( controller : f2810_type ) is
   begin
      for sector in controller.flash'Range
      loop
         put("Sector ");
         Put( to_string(controller.flash(sector).name)) ;
         Put(" Start ");
         Put( Integer( controller.flash(sector).start ) , base=>16 ) ;
         Put( " Size " );
         Put( Integer( Controller.flash(sector).length ) ) ;
         Put( " Last " ) ;
         Put( Integer( Controller.flash(sector).start +
                       Unsigned_32(Controller.flash(sector).length) - 1 ) , base=>16) ;
         New_Line;
      end loop ;
   end Show ;

end mcu.tms320 ;
