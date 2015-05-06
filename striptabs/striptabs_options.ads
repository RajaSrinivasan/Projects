
with ada.strings.unbounded ; use ada.strings.unbounded ;

with GNAT.Command_Line;

package striptabs_options is

   Version : String   := "striptabs Version 0.0";

   Verbose : boolean := false ;
   inputfilename : unbounded_string := Null_Unbounded_String ;
   outputfilename : unbounded_string := null_unbounded_string ;

   subtype TABWIDTH_RANGE_TYPE is positive range 1..8 ;
   tabwidth : TABWIDTH_RANGE_TYPE := 4 ;

   procedure ShowUsage ;
   procedure ProcessCommandLine ;
   procedure DisplayOptions ;

end striptabs_options ;
