with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
package newutil_pkg is
    defaultconfig : string :=
    "{"
    & "    ""newutil"" : " & ASCII.LF
    & "       {" & ASCII.LF
    & "         ""templatedir"" : ""template/"" , " & ASCII.LF
    & "         ""templates"" : " & ASCII.LF
    & "           { " & ASCII.LF
    & "              ""cli.ads"" : ""/$NEWPROJ/_cli.ads"" , " & ASCII.LF
    & "              ""cli.adb"" : ""/$NEWPROJ/_cli.adb"" , " & ASCII.LF
    & "              ""clitest.adb"" : ""/$NEWPROJ/.adb"" , " & ASCII.LF
    & "              ""template.gpr"" : ""/$NEWPROJ/.gpr""  " & ASCII.LF
    & "           } " & ASCII.LF
    & "      } " & ASCII.LF
    & "}" ;

    templatedir : unbounded_string := null_unbounded_string ;
    numtemplates : integer := 0 ;
    templates : array (1..16) of unbounded_string := (others => null_unbounded_string) ;
    template_values : array (1..16) of unbounded_string := (others => null_unbounded_string) ;

    procedure show_config ;
    procedure load_config( filename : string ) ;
    procedure process_file( filename : string ) ;
    procedure process_file( filename : string ;
                            outputfilename : string ;
                            progname : string ) ;
    procedure ParseConfig ;
end newutil_pkg ;
