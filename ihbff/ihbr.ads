-------------------------------------------------------------------------
-- Intel Hex Binary format support
--
-- Reference: http://en.wikipedia.org/wiki/Intel_HEX
-------------------------------------------------------------------------

with Interfaces ;
with Ada.Streams ;
with Ada.Text_Io ;

package Ihbr is
   
   type Rectype_Type is
     (
      Data_Rec ,
      End_Of_File_Rec ,
      Extended_Seg_Adr_Rec ,
      Start_Seg_Adr_Rec ,
      Extended_Lin_Adr_Rec ,
      Start_Lin_Adr_Rec ) ;
   
   type Data_Rec_Type is array(Natural range <>) of
           Interfaces.Unsigned_8 ;
      
   type Ihbr_Record_Type ( Rectype : Rectype_Type ) is
      record
	 case Rectype is
	    when Extended_Lin_Adr_Rec =>
	       Linear_Base_Address : Interfaces.Unsigned_32 ;
	    when Extended_Seg_Adr_Rec =>
	       Segment_Base_Address : Interfaces.Unsigned_16 ;
	    when Data_Rec =>
	       DataRecLen : Interfaces.Unsigned_8 ;
	       LoadOffset : Interfaces.Unsigned_16 ;
	       Data : Data_Rec_Type (0..255) ;
	    when Start_Lin_Adr_Rec =>
	       Exec_LinStart_Adr : Interfaces.Unsigned_32 ;
	    when Start_Seg_Adr_Rec =>
	       Exec_SegStart_Adr : Interfaces.Unsigned_16 ;
	    when End_Of_File_Rec =>
	       null ;
	 end case ;
      end record ;
   
   type File_Type is private ;
   
 
   procedure Open( Name : String ;
		   File : out file_type ) ;
   procedure Close( File : in out file_type ) ;
   procedure GetNext( File : in out file_type ;
		      Rec : out Ihbr_Record_Type ) ;
   procedure PutNext( File : in out file_type ;
                      Rec : Ihbr_Record_Type ) ;
private
   type file_rec_type is
      record
	 File : Ada.Text_Io.File_Type ;
	 Current_Line : Integer ;
      end record ;
   type file_type is access all file_rec_type ;
end Ihbr ;
