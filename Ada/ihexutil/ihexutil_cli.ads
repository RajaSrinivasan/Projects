with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package ihexutil_cli is                                       -- [cli/$_cli]
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   showoption : aliased boolean := false ;
   dumpdataoption : aliased boolean := false ;
   version : string := "IHEXUTIL_V01" ;
   outputname : aliased gnat.strings.string_access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end ihexutil_cli ;                                            -- [cli/$_cli]
