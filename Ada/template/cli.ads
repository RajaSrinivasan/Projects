with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package cli is                                       -- [cli/$_cli]
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   version : string := "Template_V01" ;
   outputname : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end cli ;                                            -- [cli/$_cli]
