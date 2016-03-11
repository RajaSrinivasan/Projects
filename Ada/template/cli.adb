with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;

package body cli is

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
                                      Help => "Output Name");

        GNAT.Command_Line.Getopt(config,SwitchHandler'access);
       Arg := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
       put_line("Argument " & to_string(Arg));
       put_line("Output Name " & outputname.all ) ;
       put_line("Verbosity " & boolean'Image(Verbose)) ;
    end ProcessCommandLine;

end cli ;
