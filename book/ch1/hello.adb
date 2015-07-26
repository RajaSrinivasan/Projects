with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Long_Float_Text_Io; use Ada.Long_Float_Text_Io;
with Ada.Long_Long_Float_Text_Io; use Ada.Long_Long_Float_Text_Io;

with Ada.Numerics;
procedure hello is
begin
   Put ("Value of pi is =");
   Put (Float (Ada.Numerics.Pi));
   Put(" ") ;
   Put(Long_Float(Ada.Numerics.Pi)) ;
   Put(" ") ;
   Put(Long_Long_Float(Ada.Numerics.Pi)) ;
   New_Line;

   Put ("And e is =");
   Put (Float (Ada.Numerics.e));
   Put (" ");
   Put (Long_Float (Ada.Numerics.e));
   Put (" ");
   Put (Long_Long_Float (Ada.Numerics.e));
   New_Line;

end hello;
