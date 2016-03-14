with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package digest_cli is                                       -- [cli/$_cli]
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   version : string := "Digest_V01" ;

   recursive : aliased boolean := false ;
   md5_alg : aliased boolean := false ;
   sha_alg : aliased boolean := false ;
   sha_level : aliased integer := 0 ;

   filepattern : unbounded_string := null_unbounded_string ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;

end digest_cli ;                                            -- [cli/$_cli]
