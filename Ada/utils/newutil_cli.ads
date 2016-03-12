with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package newutil_cli is
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   version : string := "newutil V01" ;

   Arg : unbounded_string := null_unbounded_string ;
   outputname : aliased gnat.strings.string_access ;
   configfilename : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end newutil_cli ;
