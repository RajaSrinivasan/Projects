with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package linecount_cli is
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   recursive : aliased boolean := false ;
   filetype : aliased unbounded_string ;
   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
end linecount_cli ;
