with Ada.Text_Io; use Ada.Text_Io;
with Ada.Float_Text_Io; use Ada.Float_Text_Io ;
with Ada.Numerics.Elementary_Functions ;
with Float_Integrate ;
with Ada.Command_Line ;
with AUnit ;
procedure Integrate_Test is
   Fn : Integer := 0 ;
   X1, X2 : Float ;

   Integrated : Float ;
   procedure Test_0 is
   begin
      Put_Line("Test_0 Sine from pi/4 to pi/2");
      Integrated := Float_Integrate.Newton_Coates_3( Ada.Numerics.Pi/4.0 , Ada.Numerics.Pi/2.0 ,
                                                     Ada.Numerics.Elementary_Functions.Sin'Access ) ;
      Put("Newton_Coates_3");
      Put(Integrated) ;
      New_Line ;
      Integrated := Float_Integrate.Newton_Coates_4( Ada.Numerics.Pi/4.0 , Ada.Numerics.Pi/2.0 ,
                                                     Ada.Numerics.Elementary_Functions.Sin'Access ) ;
      Put("Newton_Coates_4");
      Put(Integrated) ;
      New_Line ;
      Integrated := Float_Integrate.Newton_Coates_5( Ada.Numerics.Pi/4.0 , Ada.Numerics.Pi/2.0 ,
                                                     Ada.Numerics.Elementary_Functions.Sin'Access ) ;
      Put("Newton_Coates_5");
      Put(Integrated) ;
      New_Line ;
   end Test_0 ;

   procedure Test_1 is
   begin
      Put_Line("Test_1 Sinh");
      Integrated := Float_Integrate.Newton_Coates_3( X1 , X2 ,
                                                     Ada.Numerics.Elementary_Functions.Sinh'Access ) ;
      Put("Newton_Coates_3");
      Put(Integrated) ;
      New_Line ;
      Integrated := Float_Integrate.Newton_Coates_4( X1 , X2 ,
                                                     Ada.Numerics.Elementary_Functions.Sinh'Access ) ;
      Put("Newton_Coates_4");
      Put(Integrated) ;
      New_Line ;
      Integrated := Float_Integrate.Newton_Coates_5( X1 , X2 ,
                                                     Ada.Numerics.Elementary_Functions.Sinh'Access ) ;
      Put("Newton_Coates_5");
      Put(Integrated) ;
      New_Line ;
   end Test_1 ;

begin
   if Ada.Command_Line.Argument_Count < 1
   then
      Test_0 ;
   else
      Fn := Integer'Value( Ada.Command_Line.Argument(1) ) ;
      X1 := Float'Value( Ada.Command_Line.Argument(2) ) ;
      X2 := Float'Value( Ada.Command_Line.Argument(3) ) ;
   end if ;
   case Fn is
      when 1 => Test_1 ;
      when others => Put_Line("No such test");
   end case ;

end Integrate_Test ;
