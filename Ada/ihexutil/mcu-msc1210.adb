with System.Storage_ELements ; use System.Storage_Elements ;

with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_IO ;

with crc16 ;

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

   procedure GenerateHexFile( controller : msc1210_type ;
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

   procedure Get( controller : msc1210_type ;
                 romaddress : in out Unsigned_32 ;
                 blocklen : integer ;
                 End_Of_Memory : out boolean ;
                 rec : out ihbr.Ihbr_Binary_Record_Type ) is
      myrec : ihbr.ihbr_binary_record_type( ihbr.Data_Rec ) ;

   begin
      End_Of_Memory := false ;
      if romaddress > Unsigned_32(controller.flash.rom'length)
      then
         End_Of_Memory := true ;
         return ;
      end if ;

      End_Of_Memory := false ;

      myrec.description.low := romaddress ;
      myrec.description.high := Unsigned_32(Integer(romaddress)+blocklen-1) ;
      myrec.datareclen := 0 ;
      myrec.LoadOffset := Unsigned_16(romaddress) ;
      myrec.data := (others => 0) ;

      for byte in 1..blocklen
      loop
         begin
            myrec.data(Storage_Offset(byte)) := Storage_Element((Get(Controller,romaddress))) ;
            myrec.datareclen := rec.datareclen + 1 ;
            romaddress := romaddress + 1 ;
         exception
            when others =>
               exit ;
         end ;
      end loop ;
      rec  := myrec ;
   end Get ;

   function CRC( controller : msc1210_type )
                     return Unsigned_16 is
      crc : unsigned_16 := 0 ;
   begin
      crc := crc16.Compute( Controller.flash.rom.all'address , controller.flash.rom.all'Length ) ;
      return crc ;
   end CRC ;


   procedure StoreCRC( controller : in out msc1210_type ;
                       crcaddress : Unsigned_32 ) is
      tempcrc : unsigned_16 := 0 ;
   begin
      tempcrc := CRC(controller) ;
      Set( controller , crcaddress , unsigned_32(tempcrc) );
   end StoreCRC ;

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
