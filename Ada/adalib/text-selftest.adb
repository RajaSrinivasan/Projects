with Text_Io; use Text_Io ;
with Ada.Strings.Fixed ; use Ada.Strings.Fixed ;
with System.Storage_Elements ; use System.Storage_Elements ;

with Hex.Dump ; use Hex.Dump ;

package body Text.SelfTest is


   procedure EncodeTest( Input : Storage_Array ) is
   begin
      Put_Line("-------EncodeTest---------");
      Dump( Input'Address , Input'Length ) ;
      declare
         Encodedstr : String := Base64_Encode( Input ) ;
      begin
         Put_Line( EncodedStr ) ;
         Put_Line( "Decode back" ) ;
         declare
            Decodedback : Storage_Array := Base64_Decode(EncodedStr) ;
         begin
            Dump( Decodedback'Address , Decodedback'Length ) ;
         end ;
      end ;
      Put_Line("-------EncodeTest---------");
   end EncodeTest ;
   procedure EncodeTest( Input : String ) is
      InputBytes : Storage_Array( 1..Input'Length ) ;
      for InputBytes'Address use Input'Address ;
   begin
      EncodeTest( InputBytes ) ;
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
      pragma Assert( Encode( 10 ) = 'K' ) ;
      Put_Line( Integer'Image( Integer( Decode('K'))));
      declare
         Man : String := "Man" ;
         ManBytes : Storage_Array( 1 .. Storage_Offset(Man'Last) ) ;
         for ManBytes'Address use Man'Address ;
         ManEncoded : String := Base64_Encode( ManBytes ) ;
      begin
         Put(Man) ;
         Put( " encoded " ) ;
         Put_Line( ManEncoded ) ;
         ManBytes := Base64_Decode(ManEncoded) ;
         Put("Decoded back ");
         Put(Man) ;
         New_Line ;
      end ;
      EncodeTest("any carnal pleasure.");
      EncodeTest("any carnal pleasure");
      EncodeTest("any carnal pleasur");
      EncodeTest("any carnal pleasu");
      EncodeTest("any carnal pleas");
   end Test ;
end Text.SelfTest ;
