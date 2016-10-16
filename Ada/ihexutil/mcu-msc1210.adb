with System.Storage_ELements ; use System.Storage_Elements ;

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
                  romaddress : Unsigned_32 ;
                  value : Unsigned_32 ) is
   begin
      if integer(romaddress) < controller.flash.rom'last
      then
         controller.flash.rom( integer(romaddress) + 1 ) := unsigned_8(value) ;
         return ;
      end if ;
      raise Program_Error ;
   end Set ;

   function Get( controller : msc1210_type ;
                 romaddress : Unsigned_32 )
                return Unsigned_32 is
   begin
      if integer(romaddress) < controller.flash.rom'last
      then
         return Unsigned_32(controller.flash.rom( integer(romaddress) + 1 )) ;
      end if ;
      raise Program_Error ;
   end Get ;

   procedure Set( controller : msc1210_type ;
                  rom : ihbr.ihbr_Binary_Record_Type ) is
      use ihbr ;
   begin
      if rom.rectype /= ihbr.Data_Rec
      then
         raise Program_Error ;
      end if ;
      for romadr in rom.description.low .. rom.description.high
      loop
         Set( controller , Unsigned_32(romadr + 1) , Unsigned_32(rom.data(Storage_Offset(romadr-rom.description.low+1)) ) ) ;
      end loop ;
   end Set ;

   function Get( controller : msc1210_type ;
                 romaddress : Unsigned_32 ;
                blocklen : integer )
                return ihbr.ihbr_binary_record_type is
      rec : ihbr.ihbr_binary_record_type( ihbr.Data_Rec ) ;
   begin
      rec.description.low := romaddress ;
      rec.description.high := Unsigned_32(Integer(romaddress)+blocklen-1) ;
      rec.datareclen := Unsigned_8(blocklen) ;
      rec.LoadOffset := Unsigned_16(romaddress) ;
      rec.data := (others => 0) ;

      for byte in 1..blocklen
      loop
         begin
            rec.data(Storage_Offset(byte)) := Storage_Element((Get(Controller,romaddress+Unsigned_32(byte-1)))) ;
         exception
            when others =>
               exit ;
         end ;
      end loop ;

      return rec ;
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
