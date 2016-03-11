with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;

package body cli is

    procedure ShowSwitch (sw : String; argind : String; help : String) is
    begin
        Put (ASCII.HT);
        Put ('-');
        Put (sw);
        Put (ASCII.HT);
        Put (argind);
        Put (ASCII.HT);
        Put_Line (help);
    end ShowSwitch ;

    procedure ShowUsage is
    begin
        ShowSwitch( "-h" , "--help"    , "print command line help") ;
        ShowSwitch( "-v" , "--verbose" , "set verbosity") ;
    end ShowUsage ;

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
                       Switch => "-v?",
                       Long_Switch => "--verbose?",
                       Help => "Output extra verbose information");
        GNAT.Command_Line.Define_Switch (Config,
                                      output => outputname'access,
                                      Switch => "-o:",
                                      Long_Switch => "--output:",
                                      Help => "Output Name");

        GNAT.Command_Line.Getopt(config,SwitchHandler'access);
       Arg := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
       put_line("Argument " & to_string(Arg));
       put_line("Output Name " & outputname.all ) ;
       put_line("Verbosity " & Integer'Image(Verbose)) ;
    end ProcessCommandLine;

end cli ;
