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
procedure abin2hex is
   Version : String   := "abin2hex Version 0.0";
   ----------------------
   Verbose           : Boolean                                := False;
   DumpOption        : Boolean                                := False;
   crc16Option       : Boolean                                := False;
   crc32Option       : Boolean                                := False;
   OutputHexFileName : Unbounded_String := Null_Unbounded_String;
   BinFileName : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;
   PromSize         : Natural               := 0;
   LoadAddress : Natural := 0 ;
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

      Switch ("oh", "<name>", "output hex file name. use with c");
      Switch
        ("c",
         "<hex>",
         "Update binary with CRC value. Use hex value as the address");
      Switch ("c16", "", "CRC16 will be stored at the last 2 bytes");
      Switch ("c32", "", "CRC32 will be stored at the last 4 bytes");
      Switch ("LA" , "<hex>" , "Load Address. default 0") ;
      Switch ("s", "<size>", "prom size in K (bytes)");
   end ShowUsage;
   procedure ProcessCommandLine is
   begin
      loop
         case GNAT.Command_Line.Getopt ("c16 c32 d h LA: oh: s: v") is
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
            when 'h' =>
               ShowUsage;
            when 'o' =>
               if GNAT.Command_Line.Full_Switch = "oh" then
                  OutputHexFileName :=
                    To_Unbounded_String (GNAT.Command_Line.Parameter);
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
                       prom_models.Kilo *
                       Positive'Value
                         (PromSizeSpec (1 .. PromSizeSpec'Length - 1));
                  elsif PromSizeSpec (PromSizeSpec'Length) = 'M' or
                    PromSizeSpec (PromSizeSpec'Length) = 'm'
                  then
                     PromSize :=
                       Prom_Models.Mega *
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
      BinFileName := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
   end ProcessCommandLine;
begin
   ProcessCommandLine;
   if Verbose then
      Put_Line
        (Version & " ----------------------------------------------------");
      Put ("Bin File : ");
      Put_Line (To_String (BinFileName));
      if DumpOption then
         Put_Line ("Will generate output to standard output");
      end if;
      if Length (OutputHexFileName) > 0 then
         Put ("Output Hex File :");
         Put_Line (To_String (OutputHexFileName));
      end if;
      Put ("Prom Size : ");
      Put (Integer (PromSize));
      New_Line;
      Put ("Load Address : ");
      Put (Integer (LoadAddress), Base => 16);
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
   end if;
   if Length (BinFileName) = 0 then
      put_line("Need an Output hex file name");
      ShowUsage ;
      return;
   end if;
   if PromSize < 1
   then
      put_line("Need the size of the PROM module");
      ShowUsage ;
      return ;
   end if ;
   LoadBinFile ;

   if crc16Option or crc32Option then
      ComputeAndUpdateCRC;
   end if;


   if DumpOption then
      DumpBinFile;
   end if;

   if Length (OutputHexFileName) /= 0 then
      SaveHexFile;
   end if;

end abin2hex ;
