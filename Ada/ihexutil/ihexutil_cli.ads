with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Interfaces ;
with gnat.strings ;

package ihexutil_cli is                                       -- [cli/$_cli]
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   showoption : aliased boolean := false ;

   addcrcaddress : aliased Integer ;

   hexline : unbounded_string := null_unbounded_string ;
   outputname : aliased gnat.strings.string_access ;

   version : string := "IHEXUTIL_V02" ;
   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end ihexutil_cli ;                                            -- [cli/$_cli]
