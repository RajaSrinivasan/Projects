with Interfaces;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GNAT.Command_Line;

procedure ahex2bin is
   Version : String := "ahex2bin Version 0.0";
   Kilo : constant := 1024 ;
   Mega : constant := 1024 * 1024 ;
   ----------------------
   Verbose        : Boolean                                := False;
   DumpOption     : Boolean                                := False;
   OutputFileName : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;
   HexFileName : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;
   PromSize       : Natural               := 0;
   WordEraseValue : Interfaces.Unsigned_8 := 16#ff#;
   ----------------------
   procedure ShowUsage is
      procedure Switch (sw : Character; argind : String; help : String) is
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
      Switch ('h', "", "help");
      Switch ('v', "", "verbose");
      Switch ('d', "", "dump the data");
      Switch ('o', "<name>", "output file name");
      Switch ('s', "<size>", "prom size in K (bytes)");
      Switch ('e', "<hex>", "word erase value");
      Switch (' ', "", "default = 16#ff#");
   end ShowUsage;
   procedure ProcessCommandLine is
   begin
      loop
         case GNAT.Command_Line.Getopt ("d e: h o: s: v") is
            when ASCII.NUL =>
               exit;
            when 'd' =>
               DumpOption := True;
            when 'e' =>
               WordEraseValue :=
                 Interfaces.Unsigned_8'Value (GNAT.Command_Line.Parameter);
            when 'h' =>
               ShowUsage;
            when 'o' =>
               OutputFileName :=
                 Ada.Strings.Unbounded.To_Unbounded_String
                   (GNAT.Command_Line.Parameter);
            when 's' =>
               declare
                  PromSizeSpec : string := gnat.command_line.Parameter ;
               begin

                  if PromSizeSpec(PromSizeSpec'length) = 'K' or
                     PromSizeSpec(PromSizeSpec'length) = 'k'
                  then
                     PromSize := Kilo * Positive'value( PromSizeSpec(1..PromSizeSpec'Length-1)) ;
                  elsif PromSizeSpec(PromSizeSpec'length) = 'M' or
                        PromSizeSpec(PromSizeSpec'length) = 'm'
                  then
                     PromSize := Mega * Positive'value( PromSizeSpec(1..PromSizeSpec'Length-1)) ;
                  else
                     PromSize := Positive'Value (GNAT.Command_Line.Parameter) ;
                  end if;
               end ;
            when 'v' =>
               Verbose := True;
            when others =>
               raise Program_Error;
         end case;
      end loop;
      HexFileName := To_Unbounded_String( gnat.command_line.Get_Argument );
   end ProcessCommandLine;
begin
   ProcessCommandLine;
   if Verbose then
      Put_Line(Version & " ----------------------------------------------------") ;
      Put ("Hex File : ");
      Put_Line (To_String (HexFileName));
      if DumpOption then
         Put_Line ("Will generate output to standard output");
      end if;
      if Length (OutputFileName) > 0 then
         Put ("Output File :");
         Put_Line (To_String (OutputFileName));
      end if;
      Put ("Prom Size : ");
      Put (Integer (PromSize));
      New_Line;
      Put ("Erase : ");
      Put (Integer (WordEraseValue), Base => 16); New_Line ;
      Put_Line("-------------------------------------------------------------------------");
   end if;
end ahex2bin;
