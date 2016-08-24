with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package qmanager_cli is                                       -- [cli/$_cli]
   VERSION : string := "V01" ;
   NAME : String := "qmanager" ;
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   
   ServerPortNo : aliased Integer := 0 ;
   outputname : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   procedure ShowCommandLineArguments ;
   
end qmanager_cli ;                                            -- [cli/$_cli]
