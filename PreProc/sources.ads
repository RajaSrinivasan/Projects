with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Stacks ;
package Sources is
   type File_Type is
      record
         Name : Ada.Strings.Unbounded.Unbounded_String ;
         File : access Ada.Text_Io.File_Type ;
         LineNo : Natural := 0 ;
      end record ;
   function "=" (Left, Right : File_Type) return Boolean ;
   package Sources_Pkg is new Stacks( File_Type , "=" ) ;

   function Empty return Boolean ;
   function Open( Name : String ) return File_Type ;
   procedure Push( File : File_Type ) ;
   function Pop return File_Type ;

end Sources ;
