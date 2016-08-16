with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package cli is                                       -- [cli/$_cli]
   VERSION : string := "Template_V01" ;
   NAME : String := "Utility" ;
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose

   outputname : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end cli ;                                            -- [cli/$_cli]
