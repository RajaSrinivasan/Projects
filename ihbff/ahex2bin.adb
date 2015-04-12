with Interfaces;            use Interfaces;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GNAT.Command_Line;
with GNAT.Debug_Utilities;
with GNAT.CRC32;

with Prom_Models; use Prom_Models;
with Ihbr;
with Hex.dump;
with crc16;

procedure ahex2bin is
   Version : String   := "ahex2bin Version 0.1";
   Kilo    : constant := 1024;
   Mega    : constant := 1024 * 1024;
   ----------------------
   Verbose           : Boolean                                := False;
   DumpOption        : Boolean                                := False;
   crc16Option       : Boolean                                := False;
   crc32Option       : Boolean                                := False;
   OutputHexFileName : Unbounded_String := Null_Unbounded_String;
   OutputFileName    : Ada.Strings.Unbounded.Unbounded_String :=
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
      procedure Switch (sw : String; argind : String; help : String) is
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
      Switch
        ("c",
         "<hex>",
         "Update binary with CRC value. Use hex value as the address");
      Switch ("c16", "", "CRC16 will be stored at the last 2 bytes");
      Switch ("c32", "", "CRC32 will be stored at the last 4 bytes");
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
               if GNAT.Command_Line.Full_Switch = "c16" then
                  crc16Option := True;
               elsif GNAT.Command_Line.Full_Switch = "c32" then
                  crc32Option := True;
               else
                  raise Program_Error with GNAT.Command_Line.Full_Switch;
               end if;
            when 'd' =>
               DumpOption := True;
            when 'e' =>
               WordEraseValue :=
                 Interfaces.Unsigned_8'Value (GNAT.Command_Line.Parameter);
            when 'h' =>
               ShowUsage;
            when 'o' =>
               if GNAT.Command_Line.Full_Switch = "oh" then
                  OutputHexFileName :=
                    To_Unbounded_String (GNAT.Command_Line.Parameter);
               elsif GNAT.Command_Line.Full_Switch = "ob" then
                  OutputFileName :=
                    Ada.Strings.Unbounded.To_Unbounded_String
                      (GNAT.Command_Line.Parameter);
               else
                  raise Program_Error with GNAT.Command_Line.Full_Switch;
               end if;
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
      Ihbr.Open (To_String (HexFileName), myhexfile);
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
                       (myprom,
                        Integer (nextrec.LoadOffset) + Integer (db) - 1,
                        nextrec.Data (Integer (db)));
                  end loop;
               end if;
            else
               raise Ihbr.format_error with "UnknownRecType";
            end if;
         end;
      end loop;
      Ihbr.Close (myhexfile);
   end LoadHexFile;
   procedure DumpHexFile is
   begin
      Hex.dump.Dump
        (myprom.all'Address,
         PromSize,
         Blocklen    => 16,
         show_offset => True);
   end DumpHexFile;

   procedure WriteBinFile is
   begin
      ByteProm_pkg.Write (To_String (OutputFileName), myprom);
   end WriteBinFile;

   procedure ComputeAndUpdateCRC is
   begin
      if crc16Option then
         declare
            crcinit  : Unsigned_16 := 0;
            crcvalue : Unsigned_16;
         begin
            if Verbose then
               Put ("Comupting CRC16 ");
               Put ("Memory block address ");
               Put (GNAT.Debug_Utilities.Image (myprom.all'Address));
               Put (" Total Memory Size ");
               Put (Integer'Image (myprom.all'Length));
               New_Line;
            end if;
            crcvalue := crc16.Compute (myprom.all (1)'Address, PromSize - 2);
            if Verbose then
               Put ("CRC16 ");
               Put (Integer (crcvalue), Base => 16);
               New_Line;
               ByteProm_pkg.Set
                 (myprom,
                  Integer (PromSize - 2),
                  Unsigned_8 (crcvalue and 16#00ff#));
               ByteProm_pkg.Set
                 (myprom,
                  Integer (PromSize - 1),
                  Unsigned_8 (Shift_Right (crcvalue, 8)));
            end if;
         end;
      elsif crc32Option then
         declare
            crc        : GNAT.CRC32.CRC32;
            finalvalue : Interfaces.Unsigned_32;
         begin
            GNAT.CRC32.Initialize (crc);
            for b in 1 .. PromSize - 4 loop
               GNAT.CRC32.Update (crc, Character'Val (Integer (myprom (b))));
            end loop;
            finalvalue := GNAT.CRC32.Get_Value (crc);
            Put ("CRC32 ");
            Put (Unsigned_32'Image (finalvalue));
            New_Line;
            ByteProm_pkg.Set
              (myprom,
               Integer (PromSize - 4),
               Unsigned_8 (finalvalue and 16#0000_00ff#));
            ByteProm_pkg.Set
              (myprom,
               Integer (PromSize - 3),
               Unsigned_8 (Shift_Right (finalvalue and 16#0000_ff00#, 8)));
            ByteProm_pkg.Set
              (myprom,
               Integer (PromSize - 2),
               Unsigned_8 (Shift_Right (finalvalue and 16#00ff_0000#, 16)));
            ByteProm_pkg.Set
              (myprom,
               Integer (PromSize - 1),
               Unsigned_8 (Shift_Right (finalvalue and 16#ff00_0000#, 24)));
         end;
      end if;
   end ComputeAndUpdateCRC;

   procedure SaveHexFile is
      savecontext : Prom_Models.context_type;
   begin
      savecontext.blocksize := 16;
      savecontext.called    := 0;
      if Verbose then
         Put ("Saving the prom data to ");
         Put (To_String (OutputHexFileName));
         New_Line;
      end if;
      ByteProm_pkg.Save
        (To_String (OutputHexFileName),
         myprom,
         savecontext,
         Prom_Models.Converter'Access);
   end SaveHexFile;

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

      if crc16Option then
         Put ("CRC16 will be computed and stored at ");
         Put (Integer (PromSize - 2), Base => 16);
      elsif crc32Option then
         Put ("CRC32 will be computed and stored at ");
         Put (Integer (PromSize - 4), Base => 16);
      end if;
      New_Line;
      Put_Line
        ("-------------------------------------------------------------------------");
      crc16.Selftest;
   end if;
   if Length (HexFileName) = 0 then
      return;
   end if;
   LoadHexFile;
   if DumpOption then
      DumpHexFile;
   end if;
   if Length (OutputFileName) /= 0 then
      WriteBinFile;
   end if;
   if crc16Option or crc32Option then
      ComputeAndUpdateCRC;
   end if;
   if Length (OutputHexFileName) /= 0 then
      SaveHexFile;
   end if;
end ahex2bin;
