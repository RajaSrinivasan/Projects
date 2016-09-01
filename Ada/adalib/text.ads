with System;
with System.Storage_Elements;

package Text is

   CODES : constant String
     := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=" ;

   type Base64_Char is range 0..63 ;
   type Base64_String is array (Positive range <>) of Base64_Char ;
   pragma Pack( Base64_String ) ;
   function Encode( Input : Base64_Char ) return Character ;
   function Decode( Input : Character ) return Base64_Char ;

   function Base64_Decode( Input : String )
                         return System.Storage_Elements.Storage_Array ;
   function Base64_Encode( Input : System.Storage_Elements.Storage_Array )
                         return String ;
end Text ;
