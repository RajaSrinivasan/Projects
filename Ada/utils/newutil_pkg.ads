package newutil_pkg is
    defaultconfig : string :=
    "{"
    & "    ""newutil"" : " & ASCII.LF
    & "       {" & ASCII.LF
    & "         ""templatedir"" : ""$ROOT/templates"" , " & ASCII.LF
    & "         ""templates"" : " & ASCII.LF
    & "           { " & ASCII.LF
    & "              ""cli.ads"" : ""/$NEWPROJ/_cli.ads"" , " & ASCII.LF
    & "              ""cli.adb"" : ""/$NEWPROJ/_cli.adb"" , " & ASCII.LF
    & "              ""clitest.adb"" : ""/$NEWPROJ/.adb"" , " & ASCII.LF
    & "              ""template.gpr"" : ""/$NEWPROJ/.gpr""  " & ASCII.LF
    & "           } " & ASCII.LF
    & "      } " & ASCII.LF
    & "}" ;
    procedure show_config ;
    procedure load_config( filename : string ) ;
end newutil_pkg ;
