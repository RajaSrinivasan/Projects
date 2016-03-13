with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;

package body newutil_cli is

    procedure SwitchHandler
      (Switch    : String;
       Parameter : String;
       Section   : String) is
    begin
       put ("SwitchHandler " & Switch ) ;
       put (" Parameter " & Parameter) ;
       put (" Section " & Section);
       new_line ;
    end SwitchHandler ;

    procedure ProcessCommandLine is
        Config : GNAT.Command_Line.Command_Line_Configuration;
    begin
        GNAT.Command_Line.Define_Switch (Config,
                       verbose'access ,
                       Switch => "-v?",
                       Long_Switch => "--verbose?",
                       Help => "Output extra verbose information");
        GNAT.Command_Line.Define_Switch (Config,
                                      output => outputname'access,
                                      Switch => "-o:",
                                      Long_Switch => "--output:",
                                      Help => "Output Directory");
        GNAT.Command_Line.Define_Switch (Config,
                                         output => configfilename'access,
                                         Switch => "-c:",
                                         Long_Switch => "--config-file:",
                                         Help => "Configuration file (json)");
        GNAT.Command_Line.Define_Switch (Config,
                                         overwrite'access ,
                                         Switch => "-O",
                                         Long_Switch => "--Overwrite",
                                         Help => "Overwrite output files");
        GNAT.Command_Line.Define_Switch (Config,
                                         output => projectroot'access,
                                         Switch => "-R:",
                                         Long_Switch => "--Root:",
                                         Help => "Project Root");

       GNAT.Command_Line.Getopt(config,SwitchHandler'access);
       put_line("Output Name " & outputname.all ) ;
       put_line("Verbosity " & boolean'Image(Verbose)) ;

    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => False) ;
    end GetNextArgument ;

end newutil_cli ;
