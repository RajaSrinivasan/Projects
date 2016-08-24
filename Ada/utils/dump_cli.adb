with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Command_Line;

package body dump_cli is

   procedure SwitchHandler
     (Switch    : String;
      Parameter : String;
      Section   : String)
   is
   begin
      Put ("SwitchHandler " & Switch);
      Put (" Parameter " & Parameter);
      Put (" Section " & Section);
      New_Line;
   end SwitchHandler;

   procedure ProcessCommandLine is
      Config : GNAT.Command_Line.Command_Line_Configuration;
   begin
      GNAT.Command_Line.Define_Switch
        (Config,
         verbose'Access,
         Switch      => "-v?",
         Long_Switch => "--verbose?",
         Help        => "Output extra verbose information");
      GNAT.Command_Line.Define_Switch
        (Config,
         Output => Blocklen'Access ,
         Switch => "-b:" ,
         Long_Switch => "--blocklen:" ,
         Help => "Block length");
      GNAT.Command_Line.Define_Switch
        (Config,
         Output      => outputname'Access,
         Switch      => "-o:",
         Long_Switch => "--output:",
         Help        => "Output Name");
      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);

      Put_Line ("Output Name " & outputname.all);
      Put_Line ("Verbosity " & Boolean'Image (verbose));
   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

end dump_cli;
