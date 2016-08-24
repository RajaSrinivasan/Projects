with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Strings;

package dump_cli is
   NAME : constant String := "dump" ;
   VERSION : constant String := "V01.00" ;
   verbose : aliased Boolean :=
     False;              -- Option:     -v or --verbose
   Arg        : Unbounded_String := Null_Unbounded_String;
   outputname : aliased GNAT.Strings.String_Access;
<<<<<<< HEAD
   blocklen : aliased Integer := 16 ;
=======
   blocklength : aliased Integer := 16 ;
>>>>>>> 49fb81f896bb8ef7f3d580645c76026742c883b1
   procedure ProcessCommandLine;
   function GetNextArgument return String;
end dump_cli;
