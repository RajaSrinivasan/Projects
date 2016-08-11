with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Interfaces ;
with Interfaces.C ; use Interfaces.C ;
with Interfaces.C.Strings ; use Interfaces.C.Strings ;
with crc16 ;
procedure crc16test is
   Bytes : array(0..255) of Interfaces.Unsigned_8 ;   
   Crc : Interfaces.Unsigned_16 ;
   procedure Bytetest is
   begin
      Crc := Crc16.Compute( Bytes'Address , Bytes'Length ) ;
      Put("Byte array CRC ") ;
      Put(Integer( Crc ) ) ;
      New_Line ;
   end Bytetest ;   
   
   procedure SwapByteTest is
      Words : Integer := Bytes'Length / 2 ;
   begin
      Crc := 0 ;
      for Word in 1..Words
      loop
	 Crc16.Update( Crc , Bytes( Word*2 - 2 ) ' Address , 1 , Crc ) ;
	 Crc16.Update( Crc , Bytes( Word*2 - 1 ) ' Address , 1 , Crc ) ;    
      end loop ;      
      Put( "Byte Order CRC " );
      Put( Integer(Crc) ) ;
      New_Line ;
      Crc := 0 ;
      for Word in 1..Words
      loop
	 Crc16.Update( Crc , Bytes( Word*2 - 1 ) ' Address , 1 , Crc ) ;    
	 Crc16.Update( Crc , Bytes( Word*2 - 2 ) ' Address , 1 , crc ) ;
      end loop ;      
      Put( "Byte Swap Order CRC " );
      Put( Integer(Crc) ) ;
      New_Line ;
      
   end SwapByteTest ;
   
begin
   for Byte in Bytes'Range
   loop
      Bytes(Byte) := Interfaces.Unsigned_8( Byte ) ;
   end loop ;      
   Bytetest ;
   SwapByteTest ;
end crc16test ;
