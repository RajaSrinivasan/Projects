with Ada.Text_IO;
package Hex.dump.file is

   procedure Dump
     (filename    : String;
      show_offset : Boolean               := True;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

end Hex.dump.file;
