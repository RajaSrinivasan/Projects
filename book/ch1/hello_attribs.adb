with Ada.Text_IO; use Ada.Text_IO;
with Ada.Numerics;

with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;   use Ada.Float_Text_IO;

procedure hello_attribs is
begin
   Put ("Integer'first = ");
   Put (Integer'First);
   New_Line;
   Put ("Integer'last = ");
   Put (Integer'Last);
   New_Line;

   Put ("Float'Size = ");
   Put (Float'Size);
   New_Line;
   Put ("Float'Safe_First = ");
   Put (Float'Safe_First);
   New_Line;
   Put ("Float'Safe_Last = ");
   Put (Float'Safe_Last);
   New_Line;
   Put ("Float'Model_Mantissa = ");
   Put (Float'Model_Mantissa);
   New_Line;
   Put ("Float'Model_Emin = ");
   Put (Float'Model_Emin);
   New_Line;
   Put ("Float'Model_Epsilon = ");
   Put (Float'Model_Epsilon);
   New_Line;
   Put ("Float'Model_Small = ");
   Put (Float'Model_Small);
   New_Line;
   Put ("pi in float = ");
   Put (Float'Model (Ada.Numerics.Pi));
   New_Line;
   Put ("e in float = ");
   Put (Float'Model (Ada.Numerics.e));
   New_Line;
end hello_attribs;
