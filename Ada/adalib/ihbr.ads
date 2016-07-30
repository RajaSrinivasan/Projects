-------------------------------------------------------------------------
-- Intel Hex Binary format support
--
-- Reference: http://en.wikipedia.org/wiki/Intel_HEX
-------------------------------------------------------------------------
with System.Storage_Elements ;
with Interfaces; use Interfaces ;
with Ada.Streams;
with Ada.Text_IO;

package Ihbr is

   Verbose : Boolean := False;
   format_error : exception;

   type Rectype_Type is
     (Data_Rec,
      End_Of_File_Rec,
      Extended_Seg_Adr_Rec,
      Start_Seg_Adr_Rec,
      Extended_Lin_Adr_Rec,
      Start_Lin_Adr_Rec,
      Unknown_Rec);

   MAX_DATAREC_SIZE : constant := 256 ;

   type block_desc_type is
   record
       low, high : Unsigned_32 := 0 ;
   end record ;

   type Ihbr_Binary_Record_Type
     (Rectype : Rectype_Type := Unknown_Rec) is record
      case Rectype is
         when Extended_Lin_Adr_Rec =>
            Linear_Base_Address : Interfaces.Unsigned_32;
         when Extended_Seg_Adr_Rec =>
            Segment_Base_Address : Interfaces.Unsigned_16;
         when Data_Rec =>
            description : block_desc_type ;
            DataRecLen : Interfaces.Unsigned_8;
            LoadOffset : Interfaces.Unsigned_16;
            Data       : system.storage_elements.Storage_Array(1..MAX_DATAREC_SIZE) ;
         when Start_Lin_Adr_Rec =>
            Exec_LinStart_Adr : Interfaces.Unsigned_32;
         when Start_Seg_Adr_Rec =>
            Exec_SegStart_Adr : Interfaces.Unsigned_16;
         when End_Of_File_Rec =>
            null;
         when Unknown_Rec =>
            null ;
      end case;
   end record;
   type ihbr_Record_Type is access all Ihbr_Binary_Record_Type;

   type File_Type is private;
   MAX_LINE_LENGTH : constant := 300;

   procedure Open (Name : String; File : out File_Type; wordlength : integer := 1 );
   function Create (name : String) return File_Type;
   procedure Close (File : in out File_Type);
   procedure GetNext
     (File : in out File_Type;
      Rec  :    out Ihbr_Binary_Record_Type);
   procedure Show( hexrec : ihbr_Binary_Record_Type ; memory : boolean := false ) ;
   procedure PutNext (File : in out File_Type; Rec : Ihbr_Binary_Record_Type);
   function End_Of_File (file : Ihbr.File_Type) return Boolean;

   function ComputeChecksum (Str : String) return Interfaces.Unsigned_8;
   function ComputeChecksum (Bin : system.storage_elements.Storage_Array) return Interfaces.Unsigned_8 ;

private
   type file_rec_type is record
      File         : Ada.Text_IO.File_Type;
      Current_Line : Integer := 0 ;
      BaseAddress : Interfaces.Unsigned_32 := 0 ;
      wordlength : integer := 1 ;
   end record;
   type File_Type is access all file_rec_type;


end Ihbr;
