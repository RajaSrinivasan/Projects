with Ada.Text_Io ;
package hex.dump.file is

   procedure Dump
     (filename         : String ;
      show_offset      : Boolean               := True;
      Blocklen         : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile          : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

end hex.dump.file ;
