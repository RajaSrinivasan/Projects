with Ada.Text_IO; use Ada.Text_IO;
with GNAT.Command_Line;
with GNAT.Source_Info ; use GNAT.Source_Info ;

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
      GNAT.Command_Line.Set_Usage( Config ,
				   Help => NAME & " " & 
				           VERSION & " " & 
				           Compilation_ISO_Date & " " &
				     Compilation_Time ,
				   Usage => "generate a hex dump of a file");
      GNAT.Command_Line.Define_Switch
        (Config,
         Switch      => "-h",
         Long_Switch => "--help" ,
         Help        => "generate this help message" );
      GNAT.Command_Line.Define_Switch
        (Config,
<<<<<<< HEAD
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
=======
         verbose'Access,
         Switch      => "-v",
         Long_Switch => "--verbose",
         Help        => "Output extra verbose information");
     GNAT.Command_Line.Define_Switch
       (Config,
        Output      => blocklength'Access,
        Switch      => "-b:",
        Long_Switch => "--blocklength:",
        Initial => 16 ,
        Default => 16 ,
        Help        => "Block length");
>>>>>>> 49fb81f896bb8ef7f3d580645c76026742c883b1
      GNAT.Command_Line.Getopt (Config, SwitchHandler'Access);
   end ProcessCommandLine;

   function GetNextArgument return String is
   begin
      return GNAT.Command_Line.Get_Argument (Do_Expansion => True);
   end GetNextArgument;

end dump_cli;
