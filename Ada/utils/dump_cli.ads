with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Strings;

package dump_cli is
   verbose : aliased Boolean :=
     False;              -- Option:     -v or --verbose
   Arg        : Unbounded_String := Null_Unbounded_String;
   outputname : aliased GNAT.Strings.String_Access;
   procedure ProcessCommandLine;
   function GetNextArgument return String;
end dump_cli;
