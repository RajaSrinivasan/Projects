with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Command_Line;

package body linecount_cli is

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
      if Switch = "-f" then
         filetype := To_Unbounded_String (Parameter);
      end if;
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
         recursive'Access,
         Switch      => "-r",
         Long_Switch => "--recursive",
         Help        => "Process directory arguments and recurse");

      GNAT.Command_Line.Define_Switch
        (Config,
         Switch      => "-f:",
         Long_Switch => "--file-type:",
         Help        => "File types");

      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);

      Put_Line ("Verbosity " & Boolean'Image (verbose));
   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

end linecount_cli;
