with Interfaces ;
with Ada.Strings.Fixed ;
with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;

with Hex.Dump ;
package body Text is

   use System.Storage_Elements ;
   use Ada.Strings.Fixed ;

   type Bit_Type is range 0..1 ;
   type BitString_Type is array (Integer range <>) of Bit_Type ;
   pragma Pack( BitString_Type ) ;
   subtype ByteBitString_Type is BitString_Type(1..8) ;

   function Encode( Input : Base64_Char ) return Character is
      Idx : Integer := Integer(Input+1) ;
   begin
      if Verbose
      then
         Put( Integer(Input) ) ;
         Put( Integer(Input) , Base => 16 ) ;
         New_Line ;
      end if ;
      return CODES(Idx) ;
   end Encode ;

   function Decode( Input : Character ) return Integer is
      InputStr : String(1..1) := (others => Input) ;
   begin
      if Verbose
      then
         Put("Decoding "); Put( Input ) ; Put(" or ") ; Put(InputStr) ; New_Line ; Flush ;
      end if ;
      return Index( CODES , InputStr ) - 1  ;
   end Decode ;

   function Encode( Input : Storage_Array ;
                    Padding : in Integer ) return String is
      use Interfaces ;
      InpBytes : array(1..Input'Length) of Interfaces.Unsigned_8 ;
      for InpBytes'Address use Input'Address ;
      OutStr : String(1..(Input'Length/3)*4) := (others => Ascii.nul) ;
      Ib,Ob : Integer ;
   begin
      pragma Assert( Input'Length mod 3 = 0 ) ;
      pragma Assert( Padding = 1 or Padding = 2 ) ;
      for iw in 1..InpBytes'Length / 3
      loop
         Ib := 3*(Iw-1)+1 ;
         Ob := 4*(Iw-1)+1 ;
         OutStr(Ob) := Encode(Base64_Char(Shift_Right(InpBytes(Ib) and 16#Fc# , 2 ) ));
         OutStr(Ob+1) := Encode(Base64_Char(Shift_Left(InpBytes(Ib) and 16#03# , 4 ) + Shift_Right( InpBytes(Ib+1) and 16#F0# , 4 )) );
         OutStr(Ob+2) := Encode(Base64_Char(Shift_Left(InpBytes(Ib+1) and 16#0f# , 2 ) + Shift_Right(InpBytes(Ib+2) and 16#D0# , 6 )) );
         OutStr(Ob+3) := Encode(Base64_Char(InpBytes(Ib+2) and 16#3f# ) );
      end loop ;
      if Padding = 1
      then
         OutStr( OutStr'Length ) := '=' ;
      elsif Padding = 2
      then
         OutStr( OutStr'Length -1 ) := '=' ;
         OutStr( OutStr'Length ) := '=' ;
      end if ;
      return OutStr ;
   end Encode ;

   function Base64_Encode( Input : System.Storage_Elements.Storage_Array ;
                           Padding : Integer := 0 )
                         return String is
   begin
      if Input'Length mod 3 /= 0
      then
         declare
            Tempinput : System.Storage_Elements.Storage_Array(1.. 3*((Input'Length+3)/3) ) ;
         begin
            Tempinput := (others => 0) ;
            Tempinput(1..Input'Length) := Input ;
            return Base64_Encode( Tempinput , 3 - Input'Length mod 3 ) ;
         end ;
      end if ;
      declare
         Output : String( 1.. (Input'Length * 4)/3 ) ;
      begin
         Output := Encode(Input, Padding ) ;
         if Verbose
         then
            Hex.Dump.Dump(Input'Address, Input'Length );
            Hex.Dump.Dump(Output'Address , Output'Length ) ;
         end if ;
         return Output ;
      end ;
   end Base64_Encode ;

   function Decode( Input : String ) return Storage_Array is
      use Interfaces ;

      Output_Bytes : Storage_Array( 1..( (Input'Length)*3) /4 ) ;
      Output : array (1..Output_Bytes'Length) of Unsigned_8 ;
      for Output'Address use Output_Bytes'Address ;
      Ib, Ob : Integer ;
   begin
      pragma Assert( Input'Length mod 4 = 0 ) ;
      for Iw in 1..Input'Length/4
      loop
         Ib := 4*(Iw-1) + 1 ;
         Ob := 3*(Iw-1) + 1 ;
         Output(Ob) := Shift_Left(Unsigned_8(Decode(Input(Ib))),2) + Shift_Right(Unsigned_8(Decode(Input(Ib+1))) and 16#30#,4) ;

         if Input(Ib+2) = '='
         then
            Output(Ob+1) :=Shift_Left( Unsigned_8(Decode(Input(Ib+1))) and 16#0f# , 4) ;
            return Output_Bytes( 1..Storage_Offset(Ob) ) ;
         end if ;
         Output(Ob+1) :=Shift_Left( Unsigned_8(Decode(Input(Ib+1))) and 16#0f# , 4) + Shift_Right(Unsigned_8(Decode(Input(Ib+2))) and 16#3c# , 2) ;
         if Input(Ib+3) = '='
         then
            Output(Ob+2) :=Shift_Left( Unsigned_8(Decode(Input(Ib+2))) and 16#03# , 6) ;
            return Output_Bytes(1..Storage_Offset(Ob)+1 ) ;
         end if ;
         Output(Ob+2) :=Shift_Left( Unsigned_8(Decode(Input(Ib+2))) and 16#03# , 6) + Unsigned_8(Decode(Input(Ib+3))) ;
      end loop ;
      return Output_Bytes ;
   end Decode ;

   function Base64_Decode( Input : String )
                         return System.Storage_Elements.Storage_Array is
   begin
      if Input'Length mod 4 /= 0
      then
         declare
            Tempinput : String( 1..(Input'Length+4)/4) ;
         begin
            TempINput := (others => '=' ) ;
            TempInput(1..Input'Length) := Input ;
            return Base64_Decode( TempInput ) ;
         end ;
      end if ;
      declare
         OutputBytes : System.Storage_Elements.Storage_Array := Decode(Input) ;
      begin
         return OutputBytes ;
      end ;
   end Base64_Decode ;
end Text ;
