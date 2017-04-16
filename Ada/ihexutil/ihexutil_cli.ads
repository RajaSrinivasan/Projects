with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Interfaces ;
with gnat.strings ;

package ihexutil_cli is                                       -- [cli/$_cli]
   
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   showoption : aliased boolean := false ;

   addcrcaddress : aliased Integer ;
   wordlength : aliased Integer ;

   hexline : unbounded_string := null_unbounded_string ;
   outputname : aliased gnat.strings.string_access ;
   comparehexname : aliased gnat.strings.string_access ;

   mcutype : unbounded_string := null_unbounded_string ;
   mcuname : unbounded_string := null_unbounded_string ;
   
   version : string := "IHEXUTIL_V05" ;
   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

   procedure ShowArguments ;
   
end ihexutil_cli ;                                            -- [cli/$_cli]
