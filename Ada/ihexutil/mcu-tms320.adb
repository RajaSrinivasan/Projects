with System.Storage_Elements ; use System.Storage_Elements ;

with Ada.Text_Io; use ADa.Text_Io ;
with Ada.Integer_Text_IO ; use Ada.Integer_Text_IO ;

with crc16 ;

package body mcu.tms320 is

   function Create( name : string ) return f2810_type is
      this : f2810_type ;
      procedure set_sector( num : integer ; name : string ; beginadr : Unsigned_32 ; length : Unsigned_16 ) is
         thissector : sector_ptr_type := new sector_type ;
      begin
         thissector.name := to_unbounded_string (name) ;
         thissector.start := beginadr ;
         thissector.length := length ;
         sector_ptr_type(thissector).flash := new bits16_memory_block_type(1..integer(length)) ;
         thissector.flash.all := (others => 16#ffff#) ;
         this.sectors(num) := flash_ptr_type(thissector) ;
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

   overriding
   procedure GenerateHexFile( controller : f2810_type ;
                              hexfilename : string ;
                              blocklen : integer ) is
      hexfileout : ihbr.File_Type ;
      procedure OutputSector(secno : integer) is
         baseaddrrec : ihbr.ihbr_Binary_Record_Type( ihbr.Extended_Lin_Adr_Rec ) ;
         corerec : ihbr.ihbr_Binary_Record_Type( ihbr.Data_Rec ) ;
         tobewritten : integer := Integer(Controller.sectors(secno).length) ;
         flash : sector_ptr_type := sector_ptr_type( controller.sectors(secno) ) ;
         writtensofar : integer := 0 ;
      begin
         Put("Writing sector ");
         Put_Line( to_string( Controller.sectors(secno).name ) );
         baseaddrrec.Linear_Base_Address := Shift_Right(controller.sectors(secno).start , 16 );
         ihbr.PutNext(hexfileout,baseaddrrec) ;
         while writtensofar < tobewritten
         loop
            corerec.LoadOffset := Unsigned_16(writtensofar) ;
            corerec.DataRecLen := 0 ;
            for w in 1..blocklen
            loop
               corerec.Data(Storage_Offset(w)) := Storage_Element(flash.flash (writtensofar+1) / 256 ) ;
               corerec.Data(Storage_Offset(w+1)) := Storage_Element(Shift_Right(flash.flash (writtensofar+1) ,8) ) ;

               writtensofar := writtensofar + 1 ;
               corerec.DataRecLen := corerec.DataRecLen + 2 ;
            end loop ;
            ihbr.PutNext(hexfileout,corerec) ;
         end loop ;
      end OutputSector ;

   begin
      hexfileout := ihbr.Create( hexfilename );
      for sector in controller.sectors'Range
      loop
         OutputSector(sector) ;
      end loop ;
      ihbr.Close(hexfileout) ;
   end GenerateHexFile ;

   procedure Set( controller : f2810_type ;
                  romaddress : Unsigned_32 ;
                  value : Unsigned_32 ) is
      sector : integer ;
   begin
      sector := InSector( controller.sectors , romaddress ) ;
      if sector in controller.sectors'range
      then
         declare
            flash : sector_ptr_type := sector_ptr_type( controller.sectors(sector) ) ;
         begin
            flash.flash.all( integer(romaddress - flash.start) + 1) := unsigned_16(value) ;
            return ;
         end ;
      end if ;
      Put("Invalid ROM address ");
      Put( Integer(romaddress) , base => 16  ) ;
      New_Line ;
      raise Program_Error;
   end Set ;

   function Get( controller : f2810_Type ;
                 romaddress : Unsigned_32 )
                return Unsigned_32 is
      sector : integer ;
   begin
      sector := InSector( controller.sectors , romaddress ) ;
      if sector in controller.sectors'range
      then
         declare
            flash : sector_ptr_type := sector_ptr_type( controller.sectors(sector) ) ;
         begin
            return unsigned_32( flash.flash.all( integer(romaddress - flash.start) + 1)) ;
         end ;
      end if ;
      raise Program_error ;
   end Get ;

   overriding
   function WordLength( controller : f2810_Type )
                       return Integer is
   begin
      return 2 ;
   end WordLength ;

  procedure Set( controller : f2810_type ;
                 rom : ihbr.ihbr_Binary_Record_Type ) is
      use ihbr ;
      staddress : unsigned_32 := rom.description.low ;
      numwords : integer := Integer(rom.DataRecLen) / 2 ;
      nextword : unsigned_16 ;
      sector : integer ;

   begin
      if rom.rectype /= ihbr.Data_Rec
      then
         raise Program_Error ;
      end if ;
      sector := InSector( controller.sectors , staddress ) ;
      for w in 1..numwords
      loop
         nextword := Shift_Left(Unsigned_16(rom.Data( Storage_Offset(w*2 - 1 ))) , 8) +
           Unsigned_16(rom.Data( Storage_Offset(w*2) )) ;
         if sector /= InSector(controller.sectors,staddress)
         then
            Put("Sector Violation at address ");
            Put(integer(staddress)) ;
            Put(integer(staddress) , base => 16) ;
            Put(" discarding the rest of this ihbr") ;
            New_Line ;
            return ;
         end if ;
         Set( controller , staddress , unsigned_32(nextword) ) ;
         staddress := staddress + 1 ;
      end loop ;
   end Set ;

   procedure Get( controller : f2810_type ;
                  romaddress : in out Unsigned_32 ;
                  blocklen : integer ;
                  end_of_memory : out boolean ;
                  rec : out ihbr.Ihbr_Binary_Record_Type ) is

      myrec : ihbr.Ihbr_Binary_Record_Type( ihbr.Data_Rec ) ;
   begin
      if romaddress > controller.sectors(1).start + Unsigned_32(controller.sectors(1).length)
      then
         end_of_memory := true ;
         return ;
      end if ;
      end_of_memory := false ;
      if romaddress = 0
      then
         romaddress := controller.sectors(5).start ;
      end if ;

      myrec.description.low := romaddress ;
      myrec.description.high := Unsigned_32(Integer(romaddress)+blocklen-1) ;

      myrec.LoadOffset := Unsigned_16(romaddress) ;
      myrec.data := (others => 0) ;

      for word in 1..blocklen/2
      loop
         declare
            nextword : unsigned_16 := unsigned_16(Get(Controller,romaddress)) ;
         begin
            myrec.data(Storage_Offset(word*2-1)) := Storage_Element(shift_right(nextword,8)) ;
            myrec.data(Storage_Offset(word*2)) := Storage_Element( nextword mod 256 ) ;
            myrec.datareclen := myrec.DataRecLen + 1 ;
            romaddress := romaddress + 1 ;
         exception
            when others =>
               exit ;
         end ;
      end loop ;
      rec := myrec ;
   end Get ;

   function CRC( controller : f2810_Type )
                return Unsigned_16 IS
      crc : unsigned_16 := 0 ;
   begin
      for sector in controller.sectors'Range
      loop
         crc16.Update(crc , Sector_type(Controller.Sectors(sector).all).flash.all'address ,
                      Sector_Type(Controller.Sectors(sector).all).flash.all'length , crc ) ;
      end loop ;
      return crc ;
   end CRC ;

   procedure StoreCRC( controller : in out f2810_type ;
                       crcaddress : Unsigned_32 ) is
      tempcrc : unsigned_16 := 0 ;
   begin
      tempcrc := CRC(controller) ;
      Set( controller , crcaddress , Unsigned_32(tempcrc) ) ;
   end StoreCRC ;

   procedure Show( controller : f2810_type ) is
   begin
      for sector in controller.sectors'Range
      loop
         put("Sector ");
         Put( to_string(controller.sectors(sector).name)) ;
         Put(" Start ");
         Put( Integer( controller.sectors(sector).start ) , base=>16 ) ;
         Put( " Size " );
         Put( Integer( Controller.sectors(sector).length ) ) ;
         Put( " Last " ) ;
         Put( Integer( Controller.sectors(sector).start +
                       Unsigned_32(Controller.sectors(sector).length) - 1 ) , base=>16) ;
         New_Line;
         for adr in controller.sectors(sector).start ..
                    Controller.sectors(sector).start +
                       Unsigned_32(Controller.sectors(sector).length) - 1
         loop
            Put( Integer(adr) , base => 16 ) ;
            New_Line ;
         end loop ;
      end loop ;
   end Show ;

end mcu.tms320 ;
