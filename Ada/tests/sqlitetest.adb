with SQLite ;
procedure Sqlitetest is
   Mydb : SQLite.Data_Base ;
begin
   MyDb := SQLite.Open( "sqlitetest.db" ) ;
end Sqlitetest ;
