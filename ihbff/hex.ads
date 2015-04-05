with system ;
with interfaces ;

package hex is
   format_error : exception ;
   subtype Hexstring is String (1 .. 2);

   function Value (Hex : Character) return Interfaces.Unsigned_8 ;
   function Value (Hex : Hexstring) return Interfaces.Unsigned_8 ;
   function Value (Str : String) return Interfaces.Unsigned_16 ;

   function Image(bin : interfaces.unsigned_8) return hexstring ;
   function Image(bin : interfaces.unsigned_16) return string ;
   function Image(bin : interfaces.Unsigned_32) return string ;
   function Image(binptr : system.address ;
                  Length : Integer ) return String ;
end hex ;
