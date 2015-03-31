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
   
   procedure Read( Stream : not null access Ada.Streams.Root_Stream_Type'Class ;
		   Item : out Ihbr_Record_Type ) ;
   for Ihbr_Record_Type'Read use Read ;
   procedure Write( Stream : not null access Ada.Streams.Root_Stream_Type'Class ;
		    Item : in Ihbr_Record_Type ) ;
   for Ihbr_Record_Type'Write use Write ;
   
   type Ihbr_File_Type is
      record
	 File : Ada.Text_Io.File_Type ;
	 Current_Line : Integer ;
      end record ;
   procedure Open( Name : String ;
		   File : out Ihbr_File_Type ) ;
   procedure Close( File : in out Ihbr_File_Type ) ;
   procedure GetNext( File : in out Ihbr_File_Type ;
		      Rec : out Ihbr_Record_Type ) ;
   procedure PutNext( File : in out Ihbr_File_Type ;
		      Rec : Ihbr_Record_Type ) ;
end Ihbr ;
