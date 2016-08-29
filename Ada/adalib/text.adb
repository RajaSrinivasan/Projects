with Ada.Strings.Fixed ;
with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;

package body Text is

   use System.Storage_Elements ;
   use Ada.Strings.Fixed ;

   function Encode( Input : Base64_Char ) return Character is
      Idx : Integer := Integer(Input) + 1 ;
   begin
      return CODES(Idx) ;
   end Encode ;

   function Decode( Input : Character ) return Base64_Char is
      InputStr : String(1..1) := (others => Input) ;
   begin
      return Base64_Char(Index( CODES , InputStr ) - 1) ;
   end Decode ;

   function Base64_Encode( Input : System.Storage_Elements.Storage_Array )
                         return String is
   begin
      if Input'Length mod 3 /= 0
      then
         declare
            Tempinput : System.Storage_Elements.Storage_Array(1..(Input'Length+3)/3) ;
         begin
            Tempinput := (others => 0) ;
            Tempinput(1..Input'Length) := Input ;
            return Base64_Encode( Tempinput ) ;
         end ;
      end if ;
      declare
         InputBase64 : Base64_String( 1.. (Input'Length * 3 ) / 4 ) ;
         for InputBase64'Address use Input'Address ;
         Output : String( 1.. (Input'Length * 3)/4 ) ;
      begin
         for Ic in 1..Input'Length
         loop
            Output(Ic) := Encode(InputBase64(Ic)) ;
         end loop ;
         return Output ;
      end ;
   end Base64_Encode ;

   function Base64_Decode( Input : String )
                         return System.Storage_Elements.Storage_Array is
   begin
      if Input'Length mod 4 /= 0
      then
         declare
            Tempinput : String( 1..(Input'Length+4)/4) ;
         begin
            TempINput := (others => Ascii.Nul) ;
            TempInput(1..Input'Length) := Input ;
            return Base64_Decode( TempInput ) ;
         end ;
      end if ;
      declare
         TempInput : String( 1.. (Input'Length/4)*3) ;
         Output : Base64_String( 1.. (Input'Length/4) * 3 ) ;
         OutputBytes : System.Storage_Elements.Storage_Array( 1.. (Input'Length/4) * 3 ) ;
      begin
         for Ic in TempInput'Range
         loop
            Output(IC) := Decode(TempInput(IC)) ;
         end loop ;
         return OutputBytes ;
      end ;
   end Base64_Decode ;

end Text ;
