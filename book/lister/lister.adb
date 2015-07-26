with Ada.Command_Line ; use Ada.Command_Line ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Integer_Text_Io ; use Ada.Integer_Text_Io ;

procedure Lister is
   Inpfile : Ada.Text_Io.File_Type ;
   Line : String(1..256) ;
   Linelen : Natural ;
begin
   if Ada.Command_Line.Argument_Count < 1
   then
      Put_Line("usage: lister <filename>");
      return ;
   end if ;

   Open(Inpfile,In_File,Ada.Command_Line.Argument(1)) ;

   while not End_Of_File(InpFile)
   loop
      Get_Line(Inpfile,Line,Linelen) ;
      Put_Line(Line(1..Linelen)) ;
   end loop ;
   Ada.Text_Io.Close(Inpfile) ;
end Lister ;
