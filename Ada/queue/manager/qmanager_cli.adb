with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

with gnat.command_line ;
with GNAT.Source_Info ; use GNAT.Source_Info ;

package body qmanager_cli is                          -- [cli/$_cli]

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
       GNAT.Command_Line.Set_Usage( Config ,
                                   Help => NAME & " " &
                                      VERSION & " " &
                                      Compilation_ISO_Date & " " &
                                      Compilation_Time ,
                                    Usage => "que manager");
        GNAT.Command_Line.Define_Switch (Config,
                       verbose'access ,
                       Switch => "-v",
                       Long_Switch => "--verbose",
                       Help => "Output extra verbose information");

        GNAT.Command_Line.Define_Switch (Config,
                       verbose'access ,
                       Switch => "-p:",
                       Long_Switch => "--port:",
                       Help => "Output extra verbose information");

        GNAT.Command_Line.Getopt(config,SwitchHandler'access);

    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;

    procedure ShowCommandLineArguments is
    begin
       Put("Verbose ") ;
       Put(Boolean'Image( Verbose ) );
       New_Line ;
       Put("Port No ");
       Put(ServerPortNo);
       New_Line ;
    end ShowCommandLineArguments ;

end qmanager_cli ;                                   -- [cli/$_cli]
