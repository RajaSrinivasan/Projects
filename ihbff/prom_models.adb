with System.Storage_Elements ;
with ada.text_io ; use ada.text_io ;
with ada.Integer_Text_IO ; use ada.Integer_Text_IO ;
with ada.Sequential_IO ;
with interfaces ; use interfaces ;

with GNAT.CRC32;

with crc16 ;
with hex.dump ;

with Prom ;

package body Prom_Models is

   package Byte_IO is new Ada.Sequential_IO( interfaces.Unsigned_8 ) ;
   procedure Converter
     (module  :        ByteProm_pkg.module_type;
      binrec  :    out Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type)
   is
      use Interfaces;
      use system.Storage_Elements ;
      eofrec         : Ihbr.Ihbr_Binary_Record_Type (Ihbr.End_Of_File_Rec);
      datarec        : Ihbr.Ihbr_Binary_Record_Type (Ihbr.Data_Rec);
      skipthisrecord : Boolean := True;
   begin
      if context.called = 0 then
         context.called   := 1;
         context.nextbyte := 1;
      end if;
      if context.nextbyte > module.all'Length then
         binrec := eofrec;
         return;
      end if;
      datarec.DataRecLen := 0;
      datarec.LoadOffset := Unsigned_16 (context.nextbyte - 1);
      for b in 1 .. context.blocksize loop
         datarec.Data (Storage_Offset(b)) := Storage_Element( ByteProm_pkg.get(module,context.nextbyte) );
         if module.all (context.nextbyte) /= 16#ff# then
            skipthisrecord := False;
         end if;
         datarec.DataRecLen := datarec.DataRecLen + 1;
         context.nextbyte   := context.nextbyte + 1;
         if context.nextbyte > module.all'Length then
            exit;
         end if;
      end loop;
      binrec := datarec;
      if skipthisrecord then
         binrec.DataRecLen := 0;
      end if;
   end Converter ;
   function LoadHexFile( filename : string ;
                         PromSize : integer ;
                         erasevalue : interfaces.unsigned_8 := interfaces.unsigned_8'last )
                        return ByteProm_pkg.module_type is
      use system.Storage_Elements ;
      use ihbr ;

      newmodule : ByteProm_pkg.module_type := ByteProm_pkg.Create( PromSize ) ;
      myhexfile : Ihbr.File_Type;
   begin
      ByteProm_pkg.Erase(newmodule,erasevalue) ;
      Ihbr.Open (FileName, myhexfile);
      while not Ihbr.End_Of_File (myhexfile) loop
         declare
            nextrec : Ihbr.Ihbr_Binary_Record_Type;
         begin
            Ihbr.GetNext (myhexfile, nextrec);
            if nextrec.Rectype = Ihbr.End_Of_File_Rec then
               exit;
            end if;
            if nextrec.Rectype = Ihbr.Data_Rec then
               if Integer (nextrec.LoadOffset) > PromSize then
                  if Verbose then
                     Put ("Ignoring data rec for address ");
                     Put (Integer (nextrec.LoadOffset));
                     Put (" (");
                     Put (Integer (nextrec.LoadOffset), Base => 16);
                     Put (" )");
                     New_Line;
                  end if;
               else
                  for db in 1 .. nextrec.DataRecLen loop
                     ByteProm_pkg.Set
                       (newmodule ,
                        Integer (nextrec.LoadOffset) + Integer (db) - 1,
                        unsigned_8(nextrec.Data (Storage_Offset (db)))) ;
                  end loop;
               end if;
            else
               raise Ihbr.format_error with "UnknownRecType";
            end if;
         end;
      end loop;
      Ihbr.Close (myhexfile);
      return newmodule ;
   end LoadHexFile ;
   function LoadBinFile( filename : string ;
                         PromSize : integer ;
                         erasevalue : interfaces.unsigned_8 := interfaces.unsigned_8'last )
                        return ByteProm_pkg.module_type is
      newmodule : ByteProm_pkg.module_type := ByteProm_pkg.Create( PromSize ) ;
      byteio_file : Byte_IO.File_Type ;
      bytevalue : interfaces.Unsigned_8 ;
   begin
      ByteProm_pkg.Erase(newmodule,erasevalue) ;
      Byte_IO.Open(byteio_file,byte_io.in_file,filename) ;
      for b in 1..PromSize
      loop
         if byte_io.End_Of_File(byteio_file)
         then
            exit ;
         end if ;
         byte_io.Read(byteio_file,bytevalue) ;
         ByteProm_pkg.Set(newmodule,b-1,bytevalue) ;
      end loop ;
      byte_io.close(byteio_file) ;
      return newmodule ;
   end LOadBinFile ;

   procedure DumpModule( module : ByteProm_pkg.module_type ;
                         blocklen : integer := 16 ) is
   begin
      Hex.dump.Dump
        (module.all'Address,
         module.all'length ,
         Blocklen    => blocklen ,
         show_offset => True);
   end DumpModule ;
   procedure ComputeAndUpdateCRC( module : in out ByteProm_pkg.module_type ;
                                  computecrc16 : boolean := true ;
                                  computecrc32 : boolean := true ) is
      promsize : integer := module.all'length ;
      procedure ComputeAndUpdateCRC16 is
         crcinit  : Unsigned_16 := 0;
         crcvalue : Unsigned_16;
      begin
         if Verbose then
            Put ("Comupting CRC16 ");
            Put (" Total Memory Size ");
            Put (Integer'Image (module.all'Length));
            New_Line;
         end if;
         crcvalue := crc16.Compute (module.all (1)'Address, PromSize - 2);
         if Verbose then
            Put ("CRC16 ");
            Put (Integer (crcvalue), Base => 16);
            New_Line;
         end if ;
         ByteProm_pkg.Set
           (module,
            Integer (PromSize - 2),
            Unsigned_8 (crcvalue and 16#00ff#));
         ByteProm_pkg.Set
           (module,
            Integer (PromSize - 1),
            Unsigned_8 (Shift_Right (crcvalue, 8)));
      end ComputeAndUpdateCRC16 ;
      procedure ComputeAndUpdateCRC32 is
         crc        : GNAT.CRC32.CRC32;
         finalvalue : Interfaces.Unsigned_32;
      begin
         GNAT.CRC32.Initialize (crc);
         for b in 1 .. PromSize - 4 loop
            GNAT.CRC32.Update (crc, Character'Val (Integer (ByteProm_pkg.Get(module,b))));
         end loop;
         finalvalue := GNAT.CRC32.Get_Value (crc);
         if verbose
         then
            Put ("CRC32 ");
            Put (Unsigned_32'Image (finalvalue));
            New_Line;
         end if ;
         ByteProm_pkg.Set
              (module ,
               Integer (PromSize - 4),
               Unsigned_8 (finalvalue and 16#0000_00ff#));
         ByteProm_pkg.Set
           (module,
            Integer (PromSize - 3),
            Unsigned_8 (Shift_Right (finalvalue and 16#0000_ff00#, 8)));
         ByteProm_pkg.Set
              (module,
               Integer (PromSize - 2),
               Unsigned_8 (Shift_Right (finalvalue and 16#00ff_0000#, 16)));
         ByteProm_pkg.Set
              (module,
               Integer (PromSize - 1),
               Unsigned_8 (Shift_Right (finalvalue and 16#ff00_0000#, 24)));
      end ComputeAndUpdateCRC32 ;
   begin
      if computecrc16 = computecrc32
      then
         raise Program_Error ;
      end if ;
      if computecrc16
      then
         ComputeAndUpdateCRC16 ;
      else
         ComputeAndUpdateCRC32 ;
      end if ;
   end ComputeAndUpdateCRC ;

   procedure extractor
     (module  : in out ByteProm_pkg.module_type;
      binrec  :        Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type) is
   begin
      if context.called = 0 then
         context.called   := 1;
         context.nextbyte := 1;
      end if;
      null ;
   end extractor ;

end Prom_Models;
