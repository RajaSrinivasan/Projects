-------------------------------------------------------------------------
-- Intel Hex Binary format support
--
-- Reference: http://en.wikipedia.org/wiki/Intel_HEX
-------------------------------------------------------------------------

with Interfaces;
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

   type Data_Rec_Type is array (Natural range <>) of Interfaces.Unsigned_8;

   type Ihbr_Binary_Record_Type
     (Rectype : Rectype_Type := Unknown_Rec) is record
      case Rectype is
         when Extended_Lin_Adr_Rec =>
            Linear_Base_Address : Interfaces.Unsigned_32;
         when Extended_Seg_Adr_Rec =>
            Segment_Base_Address : Interfaces.Unsigned_16;
         when Data_Rec =>
            DataRecLen : Interfaces.Unsigned_8;
            LoadOffset : Interfaces.Unsigned_16;
            Data       : Data_Rec_Type (1 .. 256);
         when Start_Lin_Adr_Rec =>
            Exec_LinStart_Adr : Interfaces.Unsigned_32;
         when Start_Seg_Adr_Rec =>
            Exec_SegStart_Adr : Interfaces.Unsigned_16;
         when End_Of_File_Rec =>
            null;
         when Unknown_Rec =>
            null;
      end case;
   end record;
   type ihbr_Record_Type is access all Ihbr_Binary_Record_Type;

   type File_Type is private;
   MAX_LINE_LENGTH : constant := 300;

   procedure Open (Name : String; File : out File_Type);
   function Create (name : String) return File_Type;
   procedure Close (File : in out File_Type);

   procedure GetNext
     (File : in out File_Type;
      Rec  :    out Ihbr_Binary_Record_Type);
   procedure PutNext (File : in out File_Type; Rec : Ihbr_Binary_Record_Type);
   function End_Of_File (file : Ihbr.File_Type) return Boolean;

private
   type file_rec_type is record
      File         : Ada.Text_IO.File_Type;
      Current_Line : Integer;
   end record;
   type File_Type is access all file_rec_type;

   function ComputeChecksum (Str : String) return Interfaces.Unsigned_8;

end Ihbr;
