with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Ada.Float_Text_Io; use Ada.Float_Text_Io ;

procedure Table is
   Slices : constant := 25 ;
   X : Float := 0.0 ;
   DeltaX : Float := 1.0 / Float(Slices) ;
begin
   Put_Line(" Idx.      X     X^2    X^3");
   for P in 1..Slices+1
   loop
      Put(Integer(P) , Width => 4 ) ;
      Put(") ");
      Put(X, Aft => 4 , Exp => 0 ) ;
      Put(X*X , Aft => 4 , Exp => 0 ) ;
      Put(X**3 , Aft => 4 , Exp => 0 ) ;
      New_Line ;
      X := X + DeltaX ;
   end loop ;
end Table ;
