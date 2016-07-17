with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;

package body ihexutil_cli is                          -- [cli/$_cli]

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
                        showoption'access ,
                        Switch => "-s",
                        Long_Switch => "--show",
                        Help => "Show the contents of the hex file");
        GNAT.Command_Line.Getopt(config,SwitchHandler'access);

    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;

end ihexutil_cli ;                                   -- [cli/$_cli]
