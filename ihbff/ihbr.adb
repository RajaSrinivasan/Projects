with unchecked_deallocation ;
with ada.exceptions ;
with ada.Integer_Text_IO ;
package body ihbr is

   use ada.Text_IO ;
   use ada.Integer_Text_IO ;

   Start_Code : constant Character := ':' ;
   subtype Byte_Count   is String (1..2) ;
   subtype Hexf_Address is String (1..4) ;
   subtype Record_Type  is String (1..2) ;
   subtype Checksum     is String (1..2) ;
   subtype Hexstring    is String (1..2) ;

   procedure free is new unchecked_deallocation( file_rec_type , file_type ) ;

   function Value( Hex : Character ) return interfaces.Unsigned_8 is
   begin
      if Hex in '0' .. '9'
      then
	 return interfaces.unsigned_8(Character'Pos(Hex) - Character'Pos('0')) ;
      end if ;
      if Hex in 'a' .. 'f'
      then
	 return Interfaces.Unsigned_8(10 + Character'Pos(Hex) - Character'Pos('a')) ;
      end if ;
      if Hex in 'A' .. 'F'
      then
	 return Interfaces.Unsigned_8(10 + Character'Pos(Hex) - Character'Pos('A')) ;
      end if ;
      raise format_error with "InvalidHex" ;
   end Value ;

   function Value( Hex : hexstring ) return interfaces.unsigned_8 is
      use interfaces ;
      Vhigh, Vlow : interfaces.unsigned_8 ;
   begin
      Vhigh := Value( Hex(1) ) ;
      Vlow  := Value( Hex(2) ) ;
      return Vhigh * 16 + Vlow ;
   end Value ;
   function Value ( Str : String ) return interfaces.Unsigned_16 is
      use interfaces ;
      Result : interfaces.unsigned_16 := 0 ;
      Numbytes : Integer ;
      Nextbyte : interfaces.unsigned_8  ;
   begin
      if Str'Length /= 4
      then
	 raise Format_Error with "HexWord" ;
      end if ;
      Numbytes := Str'Length / 2 ;
      for B in 1..Numbytes
      loop
	 Nextbyte := Value( Str( (B-1)*2 + 1 .. B*2 ) ) ;
	 Result := Shift_Left(Result,8) + interfaces.unsigned_16(Nextbyte) ;
      end loop ;
      return Result ;
   end Value ;

   procedure Open( Name : String ;
                   File : out file_type ) is
      temp : file_type := new file_rec_type ;
   begin
      ada.text_io.Open(temp.File,ada.text_io.in_file,name) ;
      temp.Current_Line := 0 ;
      file := temp ;
   end open ;

   procedure Close( File : in out file_type ) is
   begin
      ada.text_io.close( file.file ) ;
      free( file ) ;
      file := null ;
   end close ;

   procedure GetNext( File : in out file_type ;
                      Rec : out Ihbr_Record_Type ) is
      input_line : string(1..MAX_LINE_LENGTH) ;
      line_length : natural ;
   begin
      ada.text_io.get_line( file.file , input_line , line_length ) ;
      declare
         newline : string( 1..line_length ) ;
         for newline'address use input_line'address ;

         Bc : Byte_Count ;
         for Bc'Address  use newline(2)'Address ;
         Bcval : interfaces.unsigned_8 ;

         Hxa : Hexf_Address ;
         for Hxa'Address use newline(4)'Address ;
         Hxaval : interfaces.Unsigned_16 ;

         Rt : Record_Type ;
         for Rt'Address  use newline(8)'Address ;
         Rtval : interfaces.unsigned_8 ;

      begin
         file.Current_Line := file.current_line + 1;
         if newline(1) /= Start_code
         then
            raise Format_Error with "StartChar" ;
         end if ;
         bcval := value( bc ) ;
         hxaval := value( hxa ) ;
         rtval := value( rt ) ;
      end ;
   exception
      when e : others =>
         put_line("Exception:");
         put("Line No: ");
         put(file.Current_Line , width => 4);
         new_line ;
         put_line( ada.exceptions.exception_name(e)) ;
         put_line( ada.exceptions.exception_message(e)) ;
         raise ;
   end GetNExt ;

   procedure PutNext( File : in out file_type ;
                      Rec : Ihbr_Record_Type ) is
   begin
      null ;
   end PutNext ;

end ihbr ;
