with Sources ;
with Ada.Command_Line ;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded ;

procedure Testsources is
   File : Sources.File_Type ;
   Id : Natural := Natural'First ;
begin
   for Src in 1..Ada.Command_Line.Argument_Count
   loop
      File := Sources.Open(Ada.Command_Line.Argument(Src)) ;
      Id := Id + 1 ;
      File.LineNo := Id ;
      Sources.Push(File) ;
      Put("Pushed ");
      Put( Id , Width => 5 );
      Put(" : ");
      Put_Line(Ada.Command_Line.Argument(Src)) ;
   end loop ;

   while not Sources.Empty
   loop
      File := Sources.Pop ;
      Put("Popped ");
      Put( File.LineNo , Width => 5 ) ;
      Put(" : ");
      Put_Line(To_String( File.Name ) ) ;
   end loop ;

end Testsources ;
