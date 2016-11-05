with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with System.Storage_Elements ;
with Interfaces ; use Interfaces ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with hex ;
with hex.dump ;
with ihbr ; use ihbr ;
with crc16 ; use crc16 ;

with ihexutil_cli ;
package body ihexutil_pkg is
   
    procedure Show( filename : string ;
		    Controller : access mcu.Controller_Type'Class := null ) is
       use System.Storage_Elements ;
       hexfile : ihbr.File_Type ;
       hexrec : ihbr.Ihbr_Binary_Record_Type ;
       linecount : Integer := 0 ;
       
   begin
      if Controller /= null
      then
         ihbr.Open( filename , hexfile , mcu.WordLength(Controller.all) );
      else
         ihbr.Open( filename , hexfile ) ;
      end if ;
       while not ihbr.End_Of_File( hexfile )
       loop
           ihbr.GetNext( hexfile , hexrec ) ;
           linecount := linecount + 1 ;
           ihbr.Show( hexrec , true ) ;
	   if Controller /= null and then Hexrec.RecType = Ihbr.Data_Rec	     
         then
              mcu.Set( Controller.all , hexrec ) ;
	   end if ;
       end loop ;
       ihbr.Close( hexfile ) ;
       Put(Integer'Image(linecount));
       Put(" lines read from ");
       Put_Line(filename);
   end Show ;
   
    procedure CopyWithCRCObs( infilename : string ;
                           outfilename : string ;
                           crcaddress : Unsigned_32 ;
                          Controller : not null access mcu.Controller_Type'Class ) is
      hexfilein, hexfileout : ihbr.File_Type ;
      hexrec : ihbr.Ihbr_Binary_Record_Type ;
      linecount : Integer := 0 ;
      CRC : unsigned_16 := 0 ;
    begin
        ihbr.Open( infilename , hexfilein , mcu.WordLength(Controller.all) );
        hexfileout := ihbr.Create( outfilename );
        while not ihbr.End_Of_File( hexfilein )
        loop
          ihbr.GetNext( hexfilein , hexrec ) ;
          linecount := linecount + 1 ;
         if hexrec.RecType = ihbr.Data_Rec
         then
            mcu.Set( Controller.all , hexrec ) ; 
         elsif hexrec.RecType = ihbr.End_Of_File_Rec
         then
            if crcaddress > 0
            then 
               mcu.StoreCRC( Controller.all , crcaddress ) ;                     
            end if ;
          end if ;
          ihbr.PutNext( hexfileout , hexrec ) ;
        end loop ;
        ihbr.Close( hexfilein ) ;
        ihbr.Close( hexfileout ) ;
        if ihexutil_cli.Verbose
        then
            Put( linecount ) ; Put( " records copied from ") ;
            Put(infilename) ; Put(" to ") ; Put( outfilename ) ;
            New_Line ;
            Put("Checksum Calculated ") ; Put( Integer(CRC) ) ;
            New_Line ;
        end if ;
   end CopyWithCRCObs ;
   
   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ;
                          crcaddress : Unsigned_32 ;
                          Controller : not null access mcu.Controller_Type'Class ) is
   begin
      mcu.LoadHexFile(Controller.all , infilename ) ;
      mcu.StoreCRC(Controller.all , crcaddress ) ;
      mcu.GenerateHexFile(Controller.all,outfilename,mcu.WordLength(Controller.all)*ihbr.WORDS_IN_LINE) ;
   end CopyWithCRC;
   
    procedure Checksum( line : string ) is
       cs : Interfaces.Unsigned_8 ;
    begin
        cs := ihbr.ComputeChecksum( line );
        Put( integer(cs) , width => 6 , base => 16 ) ;
        new_line ;
    end Checksum ;
end ihexutil_pkg ;
