with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Strings;

package newutil_cli is
   verbose : aliased Boolean :=
     False;              -- Option:     -v or --verbose
   version : String := "newutil V01";

   Arg            : Unbounded_String := Null_Unbounded_String;
   outputname     : aliased GNAT.Strings.String_Access;
   configfilename : aliased GNAT.Strings.String_Access;

   overwrite   : aliased Boolean := False;
   projectroot : aliased GNAT.Strings.String_Access;

   procedure ProcessCommandLine;
   function GetNextArgument return String;

end newutil_cli;
