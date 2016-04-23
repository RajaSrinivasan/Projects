with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Strings;

package linecount_cli is
   verbose : aliased Boolean :=
     False;              -- Option:     -v or --verbose
   recursive : aliased Boolean := False;
   filetype  : aliased Unbounded_String;
   procedure ProcessCommandLine;
   function GetNextArgument return String;
end linecount_cli;
