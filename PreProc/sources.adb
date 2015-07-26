package body Sources is

   Src_Stack : Sources_Pkg.Stk_Pkg.Vector ;
   function "=" (Left, Right : File_Type) return Boolean is
   begin
      return Ada.Strings.Unbounded."="(Left.Name,Right.Name) ;
   end "=" ;


   function Open( Name : String ) return File_Type is
      Newfile : File_Type ;
   begin
      Newfile.Name := To_Unbounded_String(Name) ;
      Newfile.File := new Ada.Text_Io.File_Type ;
      Ada.Text_Io.Open( Newfile.File.all , In_File , Name ) ;
      return Newfile ;
   end Open ;

   procedure Push( File : File_Type ) is
   begin
      Sources_Pkg.Push( Src_Stack , File ) ;
   end Push ;

   function Pop return File_Type is
      TopFile : File_Type ;
   begin
      Sources_Pkg.Pop( Src_Stack , TopFile ) ;
      return TopFile ;
   end Pop ;

   function Empty return Boolean is
   begin
      return Sources_Pkg.Empty(Src_Stack);
   end Empty ;

begin
   Src_Stack := Sources_Pkg.Create ;
end Sources ;
