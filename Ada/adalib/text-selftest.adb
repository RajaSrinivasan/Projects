with Text_Io; use Text_Io ;
with Ada.Strings.Fixed ; use Ada.Strings.Fixed ;
with System.Storage_Elements ; use System.Storage_Elements ;

with Hex.Dump ; use Hex.Dump ;

package body Text.SelfTest is

   procedure EncodeTest( Input : Storage_Array ) is
   begin
      Put_Line("-------EncodeTest---------");
      Dump( Input'Address , Input'Length ) ;
      Put_Line( Base64_Encode( Input ) ) ;
      Put_Line("-------EncodeTest---------");
   end EncodeTest ;

   procedure DecodeTest( Input : String ) is
      Decoded : Storage_Array := Base64_Decode( Input ) ;
   begin
      Put_Line("-------DecodeTest---------");
      Put_Line(Input) ;
      Dump( Decoded'Address , Decoded'Length ) ;
      Put_Line("-------DecodeTest---------");
   end DecodeTest ;

   procedure Test is
   begin
      Put_Line("Text.SelfTest") ;
      declare
         Testdata : Storage_Array( 1..32 ) ;
      begin
         for Td in Testdata'Range
         loop
            Testdata( Td ) := Storage_Element(Integer(Td) * 3) ;
         end loop ;
         for Td in Testdata'Range
         loop
            EncodeTest( Testdata( 1..Td ) ) ;
         end loop ;
      end ;
      pragma Assert( Encode( 10 ) = 'K' ) ;
      Put_Line( Integer'Image( Integer( Decode('K'))));

      declare
         Man : String := "Man" ;
         ManBytes : Storage_Array( 1 .. Storage_Offset(Man'Last) ) ;
         for ManBytes'Address use Man'Address ;
         ManEncoded : String := Base64_Encode( ManBytes ) ;
--         ManDecoded : Storage_Array := Base64_Decode( ManEncoded ) ;
      begin
--         pragma Assert( ManEncoded = "TWFu" );
--         pragma Assert( ManDecoded = ManBytes ) ;
         Put(Man) ;
         Put( " encoded " ) ;
         Put_Line( ManEncoded ) ;
         ManBytes := Base64_Decode(ManEncoded) ;
         Put("Decoded back ");
         Put(Man) ;
         New_Line ;
      end ;
   end Test ;
end Text.SelfTest ;
