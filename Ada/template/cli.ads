with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package cli is
   verbose : aliased Integer := 0 ;              -- Option:     -v or --verbose
   Arg : unbounded_string := null_unbounded_string ;
   outputname : aliased gnat.strings.string_access ;
   procedure ShowUsage ;                     -- called when -h or --help
   procedure ProcessCommandLine ;
end cli ;
