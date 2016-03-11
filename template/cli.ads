with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package cli is
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   Arg : unbounded_string := null_unbounded_string ;
   outputname : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
end cli ;
