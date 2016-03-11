package body hex.dump.file is
    procedure Dump
      (filename         : String ;
       show_offset      : Boolean               := True;
       Blocklen         : Integer               := DEFAULT_BLOCK_LENGTH;
       Outfile          : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output) is
    begin
        Ada.Text_Io.Put( outfile , "* Dump of *********") ;
        Ada.Text_Io.Put( outfile , filename ) ;
        Ada.Text_Io.Put_Line(outfile , "*********************************") ;
    end Dump ;

end hex.dump.file ;
