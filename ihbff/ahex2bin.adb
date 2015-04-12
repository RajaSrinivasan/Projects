with Interfaces;  use interfaces ;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;


with GNAT.Command_Line;
with gnat.Debug_Utilities ;
with gnat.crc32 ;

with Prom_Models; use Prom_Models;
with Ihbr;
with hex.dump ;
with crc16 ;


procedure ahex2bin is
   Version : String   := "ahex2bin Version 0.0";
   Kilo    : constant := 1024;
   Mega    : constant := 1024 * 1024;
   ----------------------
   Verbose        : Boolean                                := False;
   DumpOption     : Boolean                                := False;
   crc16Option    : boolean := false ;
   crc32Option    : boolean := false ;
   OutputHexFileName : unbounded_string := Null_Unbounded_String ;
   OutputFileName : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;
   HexFileName : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;
   PromSize       : Natural               := 0;
   WordEraseValue : Interfaces.Unsigned_8 := 16#ff#;
   ----------------------
   myprom    : ByteProm_pkg.module_type;
   myhexfile : Ihbr.File_Type;
   ----------------------
   procedure ShowUsage is
      procedure Switch (sw : string ; argind : String; help : String) is
      begin
         Put (ASCII.HT);
         Put ('-');
         Put (sw);
         Put (ASCII.HT);
         Put (argind);
         Put (ASCII.HT);
         Put_Line (help);
      end Switch;
   begin
      Put_Line (Version);
      Switch ("h", "", "help");
      Switch ("v", "", "verbose");
      Switch ("d", "", "dump the data");
      Switch ("ob", "<name>", "output binary file name");
      Switch ("oh", "<name>", "output hex file name. use with c");
      Switch ("c" , "<hex>" , "Update binary with CRC value. Use hex value as the address");
      Switch ("c16" , "" , "CRC16 will be stored at the last 2 bytes");
      Switch ("c32" , "" , "CRC32 will be stored at the last 4 bytes");
      Switch ("s", "<size>", "prom size in K (bytes)");
      Switch ("e", "<hex>", "word erase value");
      Switch ("", "", "default = 16#ff#");
   end ShowUsage;
   procedure ProcessCommandLine is
   begin
      loop
         case GNAT.Command_Line.Getopt ("c16 c32 d e: h ob: oh: s: v") is
            when ASCII.NUL =>
               exit;
            when 'c' =>
               if gnat.command_line.Full_Switch = "c16"
               then
                  crc16Option := true ;
               elsif
                 gnat.command_line.Full_Switch = "c32"
               then
                  crc32Option := true ;
               else
                  raise Program_Error with gnat.command_line.full_switch ;
               end if ;
            when 'd' =>
               DumpOption := True;
            when 'e' =>
               WordEraseValue :=
                 Interfaces.Unsigned_8'Value (GNAT.Command_Line.Parameter);
            when 'h' =>
               ShowUsage;
            when 'o' =>
               if gnat.command_line.Full_Switch = "oh"
               then
                  OutputHexFileName := To_Unbounded_String(gnat.command_line.parameter) ;
               elsif gnat.command_line.full_switch = "ob"
               then
                  OutputFileName :=
                    Ada.Strings.Unbounded.To_Unbounded_String
                      (GNAT.Command_Line.Parameter);
               else
                  raise Program_Error with gnat.command_line.Full_Switch ;
               end if ;
            when 's' =>
               declare
                  PromSizeSpec : String := GNAT.Command_Line.Parameter;
               begin

                  if PromSizeSpec (PromSizeSpec'Length) = 'K' or
                    PromSizeSpec (PromSizeSpec'Length) = 'k'
                  then
                     PromSize :=
                       Kilo *
                       Positive'Value
                         (PromSizeSpec (1 .. PromSizeSpec'Length - 1));
                  elsif PromSizeSpec (PromSizeSpec'Length) = 'M' or
                    PromSizeSpec (PromSizeSpec'Length) = 'm'
                  then
                     PromSize :=
                       Mega *
                       Positive'Value
                         (PromSizeSpec (1 .. PromSizeSpec'Length - 1));
                  else
                     PromSize := Positive'Value (GNAT.Command_Line.Parameter);
                  end if;
               end;
            when 'v' =>
               Verbose := True;
            when others =>
               raise Program_Error;
         end case;
      end loop;
      HexFileName := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
   end ProcessCommandLine;

   procedure LoadHexFile is
      use Ihbr;
   begin
      myprom := Prom_Models.ByteProm_pkg.Create (PromSize);
      Prom_Models.ByteProm_pkg.Erase (myprom);
      Ihbr.Open (To_String (HexFileName),myhexfile);
      while not Ihbr.End_Of_File (myhexfile)
      loop
         declare
            nextrec : Ihbr.Ihbr_Binary_Record_Type;
         begin
            Ihbr.GetNext (myhexfile, nextrec);
            if nextrec.Rectype = Ihbr.End_Of_File_Rec
            then
               exit;
            end if;
            if nextrec.Rectype = Ihbr.Data_Rec
            then
               if integer(nextrec.LoadOffset) > PromSize
               then
                  if verbose
                  then
                     put("Ignoring data rec for address ");
                     put(integer(nextrec.loadOffset)) ; put(" ("); put(integer(nextrec.LoadOffset),base=>16) ; put(" )");
                     new_line ;
                  end if ;
               else
                  for db in 1 .. nextrec.DataRecLen loop
                     ByteProm_pkg.Set
                       (myprom,
                        Integer (nextrec.LoadOffset) + Integer (db) - 1,
                        nextrec.Data (Integer (db)));
                  end loop;
               end if ;
            else
               raise Ihbr.format_error with "UnknownRecType";
            end if;
         end;
      end loop;
      Ihbr.Close (myhexfile);
   end LoadHexFile;
   procedure DumpHexFile is
   begin
      hex.dump.dump( myprom.all'address , PromSize , blocklen => 16 , show_offset => true ) ;
   end DumpHexFile ;

   procedure WriteBinFile is
   begin
      ByteProm_pkg.Write( to_string(OutputFileName) , myprom ) ;
   end WriteBinFile ;

   procedure ComputeAndUpdateCRC is
   begin
      if crc16Option
      then
         declare
            crcinit : unsigned_16 := 0 ;
            crcvalue : unsigned_16 ;
         begin
            if verbose
            then
               put("Comupting CRC16 ");
               put( "Memory block address "); put(gnat.Debug_Utilities.Image( myprom.all'address )) ;
               put( " Total Memory Size "); put( integer'image( myprom.all'length )) ;
               new_line ;
            end if ;
            crcvalue := crc16.Compute( myprom.all(1)'address , PromSize -2 ) ;
            if verbose
            then
               put("CRC16 "); put( integer(crcvalue) , base => 16 ) ; new_line ;
               ByteProm_pkg.Set( myprom , integer(PromSize-2) , unsigned_8( crcvalue and 16#00ff#)) ;
               ByteProm_Pkg.Set( myprom , integer(PromSize-1) , unsigned_8( shift_right(crcvalue,8) ) ) ;
            end if ;
         end ;
      elsif crc32Option then
         declare
            crc : gnat.crc32.CRC32 ;
            finalvalue : interfaces.unsigned_32 ;
         begin
            gnat.crc32.Initialize( crc ) ;
            for b in 1..PromSize-4
            loop
               gnat.crc32.update(crc,character'val( integer(myprom(b)) )) ;
            end loop ;
            finalvalue := gnat.crc32.Get_Value(crc) ;
            put("CRC32 "); put( unsigned_32'image(finalvalue) ) ; new_line ;
            ByteProm_pkg.Set( myprom , integer(PromSize-4) , unsigned_8( finalvalue and 16#0000_00ff# ));
            ByteProm_pkg.Set( myprom , integer(PromSize-3) , unsigned_8(shift_right( finalvalue and 16#0000_ff00# ,8)));
            ByteProm_pkg.Set( myprom , integer(PromSize-2) , unsigned_8(shift_right( finalvalue and 16#00ff_0000# ,16)));
            ByteProm_pkg.Set( myprom , integer(PromSize-1) , unsigned_8(shift_right( finalvalue and 16#ff00_0000# ,24)));
         end ;
      end if ;
   end ComputeAndUpdateCRC ;

   procedure SaveHexFile is
      savecontext : Prom_Models.context_type ;
   begin
      savecontext.blocksize := 16 ;
      savecontext.called := 0 ;
      if verbose
      then
         put("Saving the prom data to "); put( to_string(OutputHexFileName) ) ; new_line ;
      end if ;
      ByteProm_pkg.Save( to_string(OutputHexFileName) , myprom , savecontext ,  Prom_Models.Converter'access ) ;
   end SaveHexFile ;

begin
   ProcessCommandLine;
   if Verbose then
      Put_Line
        (Version & " ----------------------------------------------------");
      Put ("Hex File : ");
      Put_Line (To_String (HexFileName));
      if DumpOption then
         Put_Line ("Will generate output to standard output");
      end if;
      if Length (OutputFileName) > 0 then
         Put ("Output Binary File :");
         Put_Line (To_String (OutputFileName));
      end if;
      if Length (OutputHexFileName) > 0 then
         Put ("Output Hex File :");
         Put_Line (To_String (OutputFileName));
      end if;
      Put ("Prom Size : ");
      Put (Integer (PromSize));
      New_Line;
      Put ("Erase : ");
      Put (Integer (WordEraseValue), Base => 16);
      New_Line;

      if crc16Option
      then
         put("CRC16 will be computed and stored at ");
         put( integer( PromSize - 2 ) , base => 16 ) ;
      elsif crc32Option
      then
         put("CRC32 will be computed and stored at ") ;
         put( integer( PromSize - 4 ) , base => 16 ) ;
      end if ;
      New_Line ;
      put_line("-------------------------------------------------------------------------");
      crc16.Selftest ;
   end if;
   if Length (HexFileName) = 0 then
      return;
   end if;
   LoadHexFile;
   if DumpOption
   then
      DumpHexFile ;
   end if ;
   if Length(OutputFileName) /= 0
   then
      WriteBinFile ;
   end if ;
   if crc16Option or crc32Option
   then
      ComputeAndUpdateCRC ;
   end if ;
   if Length(OutputHexFileName) /= 0
   then
      SaveHexFile ;
   end if ;
end ahex2bin;
