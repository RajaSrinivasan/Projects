with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package newutil_pkg is
   defaultconfig : String :=
     "{" &
     "    ""newutil"" : " &
     ASCII.LF &
     "       {" &
     ASCII.LF &
     "         ""templatedir"" : ""template/"" , " &
     ASCII.LF &
     "         ""templates"" : " &
     ASCII.LF &
     "           { " &
     ASCII.LF &
     "              ""cli.ads"" : ""/$NEWPROJ/_cli.ads"" , " &
     ASCII.LF &
     "              ""cli.adb"" : ""/$NEWPROJ/_cli.adb"" , " &
     ASCII.LF &
     "              ""clitest.adb"" : ""/$NEWPROJ/.adb"" , " &
     ASCII.LF &
     "              ""template.gpr"" : ""/$NEWPROJ/.gpr""  " &
     ASCII.LF &
     "           } " &
     ASCII.LF &
     "      } " &
     ASCII.LF &
     "}";

   templatedir  : Unbounded_String                    := Null_Unbounded_String;
   numtemplates : Integer                             := 0;
   templates    : array (1 .. 16) of Unbounded_String :=
     (others => Null_Unbounded_String);
   template_values : array (1 .. 16) of Unbounded_String :=
     (others => Null_Unbounded_String);

   procedure show_config;
   procedure load_config (filename : String);
   procedure process_file (filename : String);
   procedure process_file
     (filename       : String;
      outputfilename : String;
      progname       : String);
   procedure ParseConfig;
end newutil_pkg;
