with Text_Io; use Text_Io ;
with Ada.Command_Line ;
with SQLite ;
procedure Sqlitetest is
   Mydb : SQLite.Data_Base ;
   procedure Initialize is
      Stmt : String :=
        "CREATE TABLE jobno " &
        "(" &
        "id INTEGER PRIMARY KEY AUTOINCREMENT, " &
        "client VARCHAR NOT NULL, " &
        "added DATE, " &
        "cmdfile VARCHAR" &
        ") ;" ;

   begin

      if Sqlite.Table_Exists( Mydb , "jobno" )
      then
         Put_Line("Table already exists") ;
      else
         Put_Line("Creating Table ");
         Put_Line(Stmt) ;
         declare
            Dbstmt : Sqlite.Statement := Sqlite.Prepare( Mydb , Stmt ) ;
         begin
            Sqlite.Step(Dbstmt) ;
            Put_Line("Table Created") ;
         end ;
      end if ;
   end Initialize ;
   use SQLite ;
begin
   MyDb := SQLite.Open( "sqlitetest.db" , Flags => Sqlite.CREATE or Sqlite.READWRITE ) ;
   Initialize ;
end Sqlitetest ;
