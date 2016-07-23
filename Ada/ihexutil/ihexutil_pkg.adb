with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with System.Storage_Elements ;
with Interfaces ; use Interfaces ;

with hex ;
with hex.dump ;
with ihbr ; use ihbr ;
package body ihexutil_pkg is
    procedure Show( filename : string ) is
       use System.Storage_Elements ;
       hexfile : ihbr.File_Type ;
       hexrec : ihbr.Ihbr_Binary_Record_Type ;
       linecount : Integer := 0 ;
    begin
       ihbr.Open( filename , hexfile );
       while not ihbr.End_Of_File( hexfile )
       loop
           ihbr.GetNext( hexfile , hexrec ) ;
           linecount := linecount + 1 ;
           case hexrec.Rectype is
              when Extended_Lin_Adr_Rec =>
                 Put("ExtLinA ");
                 Set_Col(17) ;
                 Put(integer(hexrec.Linear_Base_Address) , width => 6 ) ;
                 Put(integer(hexrec.Linear_Base_Address) , base => 16 , width => 10 ) ;
                 New_Line ;
              when Extended_Seg_Adr_Rec =>
                 Put("ExtSegA ");
                 Set_Col(10) ;
                 Put(long_integer'image(long_integer(hexrec.Segment_Base_Address))) ;
                 New_Line ;
              when Data_Rec =>
                 Put("DataRec");
                 Set_Col(10) ;
                 Put("Offset ") ;
                 Put( Integer(hexrec.LoadOffset) , Width => 6);
                 Put( Integer(hexrec.LoadOffset) , base => 16 , width => 10 );
                 put(" length") ;
                 Put( Integer(hexrec.DataRecLen) , Width => 4);
                 Put( " * ");
                 for c in 1..32
                 loop
                     if c <= Integer(hexrec.DataRecLen)
                     then
                        Put( hex.dump.CharImage( Unsigned_8(hexrec.Data(Storage_Offset(c)))) );
                     else
                        Put(' ') ;
                     end if ;
                 end loop;
                 Put( " * ");
                 Put( hex.Image( hexrec.Data'address , Integer(hexrec.DataRecLen) ) ) ;
                 New_Line ;
              when Start_Lin_Adr_Rec =>
                 Put("LinStA ");
                 Set_Col(10) ;
                 Put(long_integer'image(long_integer(hexrec.Exec_LinStart_Adr))) ;
                 New_Line ;
              when Start_Seg_Adr_Rec =>
                 Put("SegStA ");
                 Set_Col(10) ;
                 Put(long_integer'image(long_integer(hexrec.Exec_SegStart_Adr))) ;
                 New_Line ;
              when End_Of_File_Rec =>
                   Put_Line("End_Of_File_Rec") ;
                   New_Line ;
              when Unknown_Rec =>
                 null ;
           end case;
       end loop ;
       ihbr.Close( hexfile ) ;
       Put(Integer'Image(linecount));
       Put(" lines read from ");
       Put_Line(filename);
    end Show ;
    procedure Checksum( line : string ) is
       cs : Interfaces.Unsigned_8 ;
    begin
        cs := ihbr.ComputeChecksum( line );
        Put( integer(cs) , width => 6 , base => 16 ) ;
        new_line ;
    end Checksum ;
end ihexutil_pkg ;
