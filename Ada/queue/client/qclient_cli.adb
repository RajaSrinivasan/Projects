with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;
with GNAT.Source_Info ; use GNAT.Source_Info ;

package body qclient_cli is                          -- [cli/$_cli]

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
				    Usage => "Command Line utility");
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

       put_line("Output Name " & outputname.all ) ;
       put_line("Verbosity " & boolean'Image(Verbose)) ;
       put_line("Argument " & GetNextArgument ) ;
    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;

end qclient_cli ;                                   -- [cli/$_cli]
