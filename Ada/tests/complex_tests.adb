with Ada.Numerics.Complex_Types ;
with Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Complex_Text_Io ;
with Ada.Float_Text_Io ; use Ada.Float_Text_Io ;

package body Complex_Tests is
      procedure Test_Abs is
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 Put("Absolute Value of ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 Put( Ada.Numerics.Complex_Types.Modulus(C1) ) ;
	 New_Line ;
      end Test_Abs ;
      
      procedure Test_Argument is
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 Put("Argument Value of ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 Put( Ada.Numerics.Complex_Types.Argument(C1) ) ;
	 New_Line ;
      end Test_Argument ;
      
      procedure Test_Polar is
	 C1 : Ada.Numerics.Complex_Types.Complex ;
      begin
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 ) ;
	 Put("Compose from polar Value ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 , 1.0 ) ;
	 Put("Compose from polar Value 1 cycles ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 , 2.0 ) ;
	 Put("Compose from polar Value 2 cycles ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 , Ada.Numerics.Pi * 2.0 ) ;
	 Put("Compose from polar Value 2 pi cycles ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 , Ada.Numerics.Pi * 4.0 ) ;
	 Put("Compose from polar Value 4 pi cycles ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
	 C1 := Ada.Numerics.Complex_Types.Compose_From_Polar( 1.414 , 0.7854 , Ada.Numerics.Pi * 6.0 ) ;
	 Put("Compose from polar Value 6 pi cycles ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
      end Test_Polar  ;
      
      procedure Test_Conjugate is
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 Put("Conjugate of 1.0 + j is ") ;
	 C1 := Ada.Numerics.Complex_Types.Conjugate( C1 ) ;
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
      end Test_Conjugate ;
      
      procedure Test_Add is
	 use type Ada.Numerics.Complex_Types.Complex ;
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
	 C2 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 C1 := C1 + C2 ;
	 Put("Addition test ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
      end Test_Add ;
      procedure Test_Multiply is
	 use type Ada.Numerics.Complex_Types.Complex ;
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
	 C2 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 C1 := C1 * C2 ;
	 Put("Multiply test ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
      end Test_Multiply ;
      procedure Test_Divide is
	 use type Ada.Numerics.Complex_Types.Complex ;
	 C1 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
	 C2 : Ada.Numerics.Complex_Types.Complex := ( Re => 1.0 ,
						      Im => 1.0 ) ;
      begin
	 C1 := C1 / C2 ;
	 Put("Division test ");
	 Ada.Complex_Text_Io.Put(C1) ;
	 New_Line ;
      end Test_Divide ;
      
end Complex_Tests ;
