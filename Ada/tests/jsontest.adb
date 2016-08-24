with Ada.Text_Io; use Ada.Text_Io ;
with Gnatcoll.JSON ; use GNATCOLL.JSON ;

procedure Jsontest is
   Cmd : GNATCOLL.JSON.JSON_VALUE ;
   Args : JSON_VALUE ;
begin
   Cmd := GNATCOLL.JSON.Create_Object ;
   Set_Field(Cmd , "protocol" , Create("0.1"));
   Set_Field(Cmd , "command" , Create("list"));
   Args := Create_Object ;
   Set_Field( Args , "depth" , Create(Integer(5)) ) ;
   Set_Field( Args , "voltage" , Create(Float(5.5)) ) ;
   Set_Field( Cmd , "arguments" , Args ) ;
   Put_Line( Write( Cmd ) ) ;
   
   Cmd := Read( "{""command"" : ""list"" }" ) ;
   Put_Line( Write(Cmd) ) ;
   
end Jsontest ;
