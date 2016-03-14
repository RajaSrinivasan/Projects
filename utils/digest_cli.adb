with Ada.Text_Io; use Ada.Text_Io;
with gnat.command_line ;
with GNAT.MD5 ;
with GNAT.SHA1 ;
with GNAT.SHA224 ;
with GNAT.SHA256 ;
with GNAT.SHA384 ;
with GNAT.SHA512 ;

package body digest_cli is                          -- [cli/$_cli]

    procedure SwitchHandler
      (Switch    : String;
       Parameter : String;
       Section   : String) is
    begin
       if verbose
       then
           put ("SwitchHandler " & Switch ) ;
           put (" Parameter " & Parameter) ;
           put (" Section " & Section);
           new_line ;
       end if ;
       if Switch = "-s"
       then
           sha_level := integer'value( Parameter ) ;
           case sha_level is
                when 1 | 224 | 256 | 384 | 512 =>
                     null ;
                when others =>
                     Put( Parameter ) ;
                     Put( " is not a known sha algorithm level");
                     new_line;
                     raise Program_Error ;
           end case ;
           sha_alg := true ;
       end if ;
       if Switch = "-p"
       then
          filepattern := to_unbounded_string( Parameter ) ;
       end if;
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
                                      output => md5_alg'access,
                                      Switch => "-m",
                                      Long_Switch => "--md5",
                                      Help => "Use md5 algorithm");
        GNAT.Command_Line.Define_Switch (Config,
                                         output => sha_level'access,
                                         Switch => "-s:",
                                         Long_Switch => "--sha:",
                                         Help => "Use sha algorithm" );
        GNAT.Command_Line.Define_Switch( Config ,
                                         output => Recursive'access ,
                                         Switch => "-r" ,
                                         Long_Switch => "--recursive" ,
                                         Help => "Recurse into the provided directory") ;
        GNAT.Command_Line.Define_Switch( Config ,
                                         Switch => "-p!" ,
                                         Long_Switch => "--pattern!" ,
                                         Help => "File name pattern to search for") ;

        GNAT.Command_Line.Getopt(config,SwitchHandler'access);
        put_line("Verbosity " & boolean'Image(Verbose)) ;

    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;

end digest_cli ;                                   -- [cli/$_cli]
