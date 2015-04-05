with Unchecked_Deallocation;
with Ada.Exceptions;
with Ada.Integer_Text_IO;

with hex;

package body Ihbr is

   use Ada.Text_IO;
   use Ada.Integer_Text_IO;

   Start_Code : constant Character := ':';
   subtype Byte_Count is String (1 .. 2);
   subtype Hexf_Address is String (1 .. 4);
   subtype Record_Type is String (1 .. 2);
   subtype Checksum is String (1 .. 2);

   databegin : constant := 10;

   procedure free is new Unchecked_Deallocation (file_rec_type, File_Type);

   function ComputeChecksum (Str : String) return Interfaces.Unsigned_8 is
      use Interfaces;
      Cs       : Interfaces.Unsigned_16            := 0;
      Result   : Interfaces.Unsigned_8;
      Numbytes : Integer;
      Nextbyte : Interfaces.Unsigned_8;
      Mystr    : constant String (1 .. Str'Length) := Str;
   begin
      if Str'Length mod 2 /= 0 then
         raise Program_Error with "OddLengthStr";
      end if;
      Numbytes := Str'Length / 2;
      for byte in 1 .. Numbytes loop
         Nextbyte := hex.Value (Mystr ((byte - 1) * 2 + 1 .. byte * 2));
         Cs       := Cs + Interfaces.Unsigned_16 (Nextbyte);
      end loop;
      Result := Interfaces.Unsigned_8 (Cs and 16#00ff#);
      Result := not Result;
      return Result + 1;
   end ComputeChecksum;

   procedure Open (Name : String; File : out File_Type) is
      temp : File_Type := new file_rec_type;
   begin
      Ada.Text_IO.Open (temp.File, Ada.Text_IO.In_File, Name);
      temp.Current_Line := 0;
      File              := temp;
   end Open;

   procedure Close (File : in out File_Type) is
   begin
      Ada.Text_IO.Close (File.File);
      free (File);
      File := null;
   end Close;

   procedure GetNext
     (File : in out File_Type;
      Rec  :    out Ihbr_Binary_Record_Type)
   is
      use Interfaces;
      input_line  : String (1 .. MAX_LINE_LENGTH);
      line_length : Natural;
   begin
      Ada.Text_IO.Get_Line (File.File, input_line, line_length);
      declare
         newline : String (1 .. line_length);
         for newline'Address use input_line'Address;

         Bc : Byte_Count;
         for Bc'Address use newline (2)'Address;
         Bcval : Interfaces.Unsigned_8;

         Hxa : Hexf_Address;
         for Hxa'Address use newline (4)'Address;
         Hxaval : Interfaces.Unsigned_16;

         Rt : Record_Type;
         for Rt'Address use newline (8)'Address;
         Rtval : Interfaces.Unsigned_8;

         Cs        : Checksum;
         Csval     : Interfaces.Unsigned_8;
         calccsval : Interfaces.Unsigned_8;

      begin
         File.Current_Line := File.Current_Line + 1;
         if newline (1) /= Start_Code then
            raise format_error with "StartChar";
         end if;

         Cs        := newline (line_length - 1 .. line_length);
         Csval     := hex.Value (Cs);
         calccsval := ComputeChecksum (newline (2 .. newline'Length - 2));
         if Csval /= calccsval then
            raise format_error with "Checksum";
         else
            if Verbose then
               Put ("Line ");
               Put (File.Current_Line, Width => 5);
               Put_Line (" checksum ok");
            end if;
         end if;

         Bcval  := hex.Value (Bc);
         Hxaval := hex.Value (Hxa);

         Rtval := hex.Value (Rt);
         case Rectype_Type'Val (Rtval) is
            when Data_Rec =>
               declare
                  drdata : Ihbr_Binary_Record_Type (Data_Rec);
               begin
                  drdata.LoadOffset := Hxaval;
                  drdata.DataRecLen := Bcval;
                  for byte in 1 .. Integer (Bcval) loop
                     drdata.Data (byte) :=
                       hex.Value
                         (newline
                            (databegin + 2 * (byte - 1) ..
                                 databegin + 2 * (byte - 1) + 1));
                  end loop;
                  Rec := drdata;
               end;

            when End_Of_File_Rec =>
               if Verbose then
                  Put_Line ("End of File Record Found");
               end if;
               Rec := (Rectype => End_Of_File_Rec);

            when others =>
               raise format_error with "RecordType";
         end case;

      end;

   exception
      when e : others =>
         Put_Line ("Exception:");
         Put ("Line No: ");
         Put (File.Current_Line, Width => 4);
         New_Line;
         Put_Line (Ada.Exceptions.Exception_Name (e));
         Put_Line (Ada.Exceptions.Exception_Message (e));
         raise;
   end GetNext;

   procedure PutNext
     (File : in out File_Type;
      Rec  :        not null ihbr_Record_Type)
   is
   begin
      null;
   end PutNext;

   function End_Of_File (file : Ihbr.File_Type) return Boolean is
   begin
      return Ada.Text_IO.End_Of_File (file.File);
   end End_Of_File;

end Ihbr;
