with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_IO ;

package body mcu.msc1210 is


   function Create( name : string ) return msc1210_type is
      this : msc1210_type ;
   begin
      Initialize( this , name ) ;
      this.flash.start := 0 ;
      this.flash.length := 32 * 1024 ;
      this.flash.rom := new bits8_memory_block_type( 1..integer(this.flash.length) ) ;
      return this ;
   end Create ;


   procedure Set( controller : msc1210_type ;
                  ramaddress : Unsigned_32 ;
                  value : Unsigned_32 ) is
   begin
      if integer(ramaddress) < controller.flash.rom'last
      then
         controller.flash.rom( integer(ramaddress) + 1 ) := unsigned_8(value) ;
         return ;
      end if ;
      raise Program_Error ;
   end Set ;

   function Get( controller : msc1210_type ;
                 ramaddress : Unsigned_32 )
                return Unsigned_32 is
   begin
      if integer(ramaddress) < controller.flash.rom'last
      then
         return Unsigned_32(controller.flash.rom( integer(ramaddress) + 1 )) ;
      end if ;
      raise Program_Error ;
   end Get ;

   procedure Show( controller : msc1210_type ) is
   begin
      Put(" Start ");
      Put( Integer( controller.flash.start ) , base=>16 ) ;
      Put( " Size " );
      Put( Integer( Controller.flash.length ) ) ;
      Put( " Last " ) ;
      Put( Integer( Controller.flash.start +
             Unsigned_32(Controller.flash.length - 1 )) , base=>16) ;
      new_line ;
   end Show ;

end mcu.msc1210 ;
