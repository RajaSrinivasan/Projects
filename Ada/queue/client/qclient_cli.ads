with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with gnat.strings ;

package qclient_cli is                                       -- [cli/$_cli]
   VERSION : string := "V01" ;
   NAME : String := "qclient" ;
   verbose : aliased boolean := false ;              -- Option:     -v or --verbose
   
   ListOption : aliased Boolean := False ;
   DeleteOption : aliased Boolean := false ;
   
   Servernodename : aliased Gnat.Strings.String_Access := new String'("localhost") ;
   ServerPortNumber : aliased Integer ;
   AtOption : aliased Gnat.Strings.String_Access ;
   HourlyOption : aliased Gnat.Strings.String_Access ;
   WeeklyOption : aliased Gnat.Strings.String_Access ;
   MonthlyOption : aliased Gnat.Strings.String_Access ;
   
   LogDestination : aliased Gnat.Strings.String_Access ;
   EnvironmentFile : aliased Gnat.Strings.String_Access ;

   procedure ProcessCommandLine ;
   function GetNextArgument return String ;
   procedure ShowCommandLineArguments ;
   
end qclient_cli ;                                            -- [cli/$_cli]
