with Text_Io ; use Text_Io ;

package body Csv is
   function Open
     (Name : String;
      Separator : String)
      return File_Type
   is
      File : File_Type := new File_Object_Type ;
   begin

      Gnat.Awk.Add_File( Name , File.Session ) ;
      Gnat.Awk.Set_Field_Separators( Separator , File.Session ) ;
      Gnat.Awk.Open( Session => File.Session ) ;
      Gnat.Awk.Get_Line( Session => File.Session ) ;
      File.No_Columns := Integer(Gnat.Awk.Number_Of_Fields(File.Session)) ;
      if Debug
      then
         Text_Io.Put("Number of Fields ");
         Text_Io.Put_Line( Integer'Image(Integer(Gnat.Awk.Number_Of_Fields( File.Session ) ) ) ) ;
      end if ;
      for Fld in 1..File.No_Columns
      loop
         declare
            use String_Vectors_Pkg ;
            Columnname : String := Gnat.Awk.Field(Gnat.Awk.Count(Fld),File.Session) ;
            Oldentry : String_Vectors_Pkg.Cursor ;
         begin
            if Debug
            then
               Put("Field "); Put_Line( Columnname ) ;
            end if;
            Oldentry := String_Vectors_Pkg.Find( File.Field_Names , Columnname ) ;
            if Oldentry /= String_Vectors_Pkg.No_Element
            then
               raise Duplicate_Column ;
            end if ;
            String_Vectors_Pkg.Append( File.Field_Names , Columnname ) ;
         end ;
      end loop ;
      File.Current_Line := 0 ;
      return File ;
   end Open;

   -----------
   -- Close --
   -----------

   procedure Close (File : in out File_Type) is
   begin
      String_Vectors_Pkg.Clear( File.Field_Names ) ;
      Gnat.Awk.Close( File.session ) ;
   end Close;

   ----------------
   -- No_Columns --
   ----------------

   function No_Columns (File : File_Type) return Integer is
   begin
      return File.No_Columns ;
   end No_Columns;

   function Field_Name
     (File : File_Type;
      Column : Integer)
      return String
   is
      Ptr : String_Vectors_Pkg.Cursor ;
   begin
      Ptr := String_Vectors_Pkg.To_Cursor(File.Field_Names,Column);
      return String_Vectors_Pkg.Element( Ptr ) ;
   end Field_Name;

   procedure Get_Line (File : in out File_Type) is
   begin
      Gnat.Awk.Get_Line( Session => File.Session ) ;
      if File.No_Columns /= Integer(Gnat.Awk.Number_Of_Fields(File.Session))
      then
         if DEBUG
         then
            Put("Invalid line in input file");
            Put_Line( Gnat.Awk.Field( 0 , File.Session ) );
         end if ;
      end if ;
      File.Current_Line := File.Current_Line + 1 ;
   end Get_Line;

   function Line_No (File : File_Type) return Integer is
   begin
      return File.Current_Line;
   end Line_No;

   function End_Of_File
     (File : File_Type)
      return Boolean
   is
   begin
      return Gnat.Awk.End_Of_File(File.Session) ;
   end End_Of_File;

   function Field
     (File : File_Type;
      Column : Integer)
      return String
   is
   begin
      return Gnat.Awk.Field( Gnat.Awk.Count( Column ) , File.Session ) ;
   end Field;

   function Field( File : File_Type ; Name : String )
                 return String is
      Index : String_Vectors_Pkg.Extended_Index ;
   begin
      Index := String_Vectors_Pkg.Find_Index( File.Field_Names , Name ) ;
      return Field( File , Integer(Index) ) ;
   end Field ;

end Csv;
