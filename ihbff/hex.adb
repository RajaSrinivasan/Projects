package body hex is

   use System;

   Nibble_Hex : constant String := "0123456789abcdef";


   function Value (Hex : Character) return Interfaces.Unsigned_8 is
   begin
      if Hex in '0' .. '9' then
         return Interfaces.Unsigned_8
             (Character'Pos (Hex) - Character'Pos ('0'));
      end if;
      if Hex in 'a' .. 'f' then
         return Interfaces.Unsigned_8
             (10 + Character'Pos (Hex) - Character'Pos ('a'));
      end if;
      if Hex in 'A' .. 'F' then
         return Interfaces.Unsigned_8
             (10 + Character'Pos (Hex) - Character'Pos ('A'));
      end if;
      raise format_error with "InvalidHex";
   end Value;

   function Value (Hex : Hexstring) return Interfaces.Unsigned_8 is
      use Interfaces;
      Vhigh, Vlow : Interfaces.Unsigned_8;
   begin
      Vhigh := Value (Hex (1));
      Vlow  := Value (Hex (2));
      return Vhigh * 16 + Vlow;
   end Value;
   function Value (Str : String) return Interfaces.Unsigned_16 is
      use Interfaces;
      Result   : Interfaces.Unsigned_16 := 0;
      Numbytes : Integer;
      Nextbyte : Interfaces.Unsigned_8;
   begin
      if Str'Length /= 4 then
         raise format_error with "HexWord";
      end if;
      Numbytes := Str'Length / 2;
      for B in 1 .. Numbytes loop
         Nextbyte := Value (Str ((B - 1) * 2 + 1 .. B * 2));
         Result := Shift_Left (Result, 8) + Interfaces.Unsigned_16 (Nextbyte);
      end loop;
      return Result;
   end Value;

   function Image(bin : interfaces.unsigned_8) return hexstring is
      use interfaces ;
      img : hexstring ;
      Lnibble : interfaces.unsigned_8 := bin and 16#0f#;
      Hnibble : interfaces.unsigned_8 := interfaces.Shift_Right( bin and 16#f0# , 4 ) ;
   begin
      img(1) := Nibble_Hex( integer( hnibble ) + 1 ) ;
      img(2) := Nibble_Hex( integer( lnibble ) + 1 ) ;
      return img ;
   end Image ;

   function Image(bin : interfaces.unsigned_16) return string is
      use interfaces ;
      img : string(1..4) ;
   begin
      img(1..2) := image( interfaces.unsigned_8( shift_right(bin and 16#ff00#,8))) ;
      img(3..4) := image( interfaces.unsigned_8( bin and 16#00ff# ));
      return img ;
   end Image ;

   function Image(bin : interfaces.unsigned_32) return string is
      use interfaces ;
      img : string(1..8) ;
   begin
      img(1..2) := image( interfaces.unsigned_8( shift_right(bin and 16#ff00_0000#,24))) ;
      img(3..4) := image( interfaces.unsigned_8( shift_right(bin and 16#00ff_0000#,16))) ;
      img(3..4) := image( interfaces.unsigned_8( shift_right(bin and 16#0000_ff00#, 8))) ;
      img(7..8) := image( interfaces.unsigned_8( bin and 16#0000_00ff# )) ;
      return img ;
   end Image ;


   function Image(binptr : system.address ;
                  Length : Integer ) return String is
      use Interfaces ;
      img : string ( 1.. 2*Length ) ;
      bytes : array( 1..length ) of interfaces.unsigned_8 ;
      for bytes'address use binptr ;
      hexstr : hexstring ;
   begin
      for binptr in 1..length
      loop
         hexstr := image( bytes(binptr) ) ;
         img(2*(binptr-1)+1 .. 2*(binptr-1)+2) := hexstr ;
      end loop ;
      return img ;
   end Image ;

end hex;
