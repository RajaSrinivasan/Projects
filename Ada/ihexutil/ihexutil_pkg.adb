with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with System.Storage_Elements ;
with Interfaces ; use Interfaces ;

with hex ;
with hex.dump ;
with ihbr ; use ihbr ;
with crc16 ; use crc16 ;

with ihexutil_cli ;
package body ihexutil_pkg is
    procedure Show( filename : string ;
                    memory : boolean := false ) is
       use System.Storage_Elements ;
       hexfile : ihbr.File_Type ;
       hexrec : ihbr.Ihbr_Binary_Record_Type ;
       linecount : Integer := 0 ;
       wordlength : integer := 1 ;
    begin
       if ihexutil_cli.wordlength > 0
       then
          wordlength := ihexutil_cli.wordlength ;
       end if ;
       ihbr.Open( filename , hexfile , wordlength );
       while not ihbr.End_Of_File( hexfile )
       loop
           ihbr.GetNext( hexfile , hexrec ) ;
           linecount := linecount + 1 ;
           ihbr.Show( hexrec , memory ) ;
       end loop ;
       ihbr.Close( hexfile ) ;
       Put(Integer'Image(linecount));
       Put(" lines read from ");
       Put_Line(filename);
    end Show ;
    procedure CopyWithCRC( infilename : string ;
                           outfilename : string ;
                           crcaddress : integer ) is
      hexfilein, hexfileout : ihbr.File_Type ;
      hexrec : ihbr.Ihbr_Binary_Record_Type ;
      linecount : Integer := 0 ;
      checksum : Interfaces.Unsigned_16 := 0 ;
    begin
        ihbr.Open( infilename , hexfilein );
        hexfileout := ihbr.Create( outfilename );
        while not ihbr.End_Of_File( hexfilein )
        loop
          ihbr.GetNext( hexfilein , hexrec ) ;
          linecount := linecount + 1 ;
          if hexrec.RecType = ihbr.Data_Rec
          then
              crc16.Update( checksum , hexrec.Data(1)'Address , Integer(hexrec.DataRecLen) , checksum ) ;
          elsif hexrec.RecType = ihbr.End_Of_File_Rec
          then
            if crcaddress > 0
            then
                declare
                   csrec : ihbr.Ihbr_Binary_Record_Type( ihbr.Data_Rec ) ;
                begin
                   csrec.DataRecLen := 2 ;
                   csrec.Data(1) := System.Storage_Elements.Storage_Element(checksum and 16#00ff#) ;
                   csrec.Data(2) := System.Storage_Elements.Storage_Element(Shift_Right(checksum,8)) ;
                   csrec.LoadOffset := Unsigned_16(crcaddress) ;
                   ihbr.PutNext( hexfileout , csrec ) ;
                end ;
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
            Put("Checksum Calculated ") ; Put( Integer(checksum) ) ;
            New_Line ;
        end if ;
    end CopyWithCRC ;
    procedure Checksum( line : string ) is
       cs : Interfaces.Unsigned_8 ;
    begin
        cs := ihbr.ComputeChecksum( line );
        Put( integer(cs) , width => 6 , base => 16 ) ;
        new_line ;
    end Checksum ;
end ihexutil_pkg ;
