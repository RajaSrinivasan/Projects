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
                    memory : boolean := false ;
		    Controller : access Ramdesc.Controller_Type := null ) is
       use System.Storage_Elements ;
       hexfile : ihbr.File_Type ;
       hexrec : ihbr.Ihbr_Binary_Record_Type ;
       linecount : Integer := 0 ;
       wordlength : integer := 1 ;
       
       function VerifyRange( Sector : Ramdesc.Sector_Type ; Desc : Ihbr.Block_Desc_Type ) return Boolean is
       begin
	  if Desc.Low >= Sector.Start and
	     Desc.Low < Sector.Start + Unsigned_32(Sector.Length) 
	  then
	     if Desc.High >= Sector.Start + Unsigned_32(Sector.Length)
	     then
		Put(Integer(Desc.High) , Base => 16 ) ; Put(" >= "); Put( Integer(Sector.Start) + Integer(Sector.Length) , Base => 16 ) ; New_Line ;
		return False ;
	     end if ;
	  end if ;
	  return True ;
       end VerifyRange ;
       procedure ReportRangeViolation( Sector : Ramdesc.Sector_Type ; Desc : Ihbr.Ihbr_Binary_Record_Type ) is
       begin
	  Put("Address violation : ") ;
	  Put(To_String(Sector.Name)) ;
	  New_Line ;
       end ReportRangeViolation ;       
       procedure VerifyRange is
       begin
	  for Sector in Controller.Flash'Range
	  loop
	     if not VerifyRange( Controller.Flash(Sector) , Hexrec.Description )
	     then
		ReportRangeViolation( Controller.Flash(Sector) , Hexrec ) ;
	     end if ;
	  end loop ;	  
       end VerifyRange ;       

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
	   if Controller /= null and then Hexrec.RecType = Ihbr.Data_Rec	     
	   then
	      VerifyRange ;
	   end if ;
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
