with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;

package body linecount_cli is

    procedure SwitchHandler
      (Switch    : String;
       Parameter : String;
       Section   : String) is
    begin
       put ("SwitchHandler " & Switch ) ;
       put (" Parameter " & Parameter) ;
       put (" Section " & Section);
       new_line ;
       if switch = "-f"
       then
          filetype := to_unbounded_string(parameter) ;
       end if ;
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
                                      recursive'access ,
                                      Switch => "-r",
                                      Long_Switch => "--recursive",
                                      Help => "Process directory arguments and recurse");

        GNAT.Command_Line.Define_Switch (Config,
                                         Switch => "-f:",
                                         Long_Switch => "--file-type:",
                                         Help => "File types");

        GNAT.Command_Line.Getopt(config,SwitchHandler'access);

        put_line("Verbosity " & boolean'Image(Verbose)) ;
    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;

end linecount_cli ;
