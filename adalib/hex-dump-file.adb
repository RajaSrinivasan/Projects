with Ada.Streams.Stream_IO;

package body hex.dump.file is
    procedure Dump
      (filename         : String ;
       show_offset      : Boolean               := True;
       Blocklen         : Integer               := DEFAULT_BLOCK_LENGTH;
       Outfile          : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output) is

       use Ada.Streams ;
       file :  Ada.Streams.Stream_IO.File_Type;
       stream : Ada.Streams.Stream_IO.Stream_Access;

       buffer : Ada.Streams.Stream_Element_Array(1..Ada.Streams.Stream_Element_Offset(blocklen)) ;
       bufferlen : Ada.Streams.Stream_Element_Offset ;

    begin
        Ada.Text_Io.Put( outfile , "* Dump of *********") ;
        Ada.Text_Io.Put( outfile , filename ) ;
        Ada.Text_Io.Put_Line(outfile , "*********************************") ;
        Ada.Streams.Stream_IO.Open(file,
                                   Ada.Streams.Stream_IO.In_File,
                                   filename );
        stream := Ada.Streams.Stream_Io.Stream(file);
        loop
            Stream.Read( buffer , bufferlen );
            if bufferlen = 0
            then
               exit ;
            end if ;
            hex.dump.dump( buffer'address ,
                           integer(bufferlen),
                           show_offset ,
                           blocklen ,
                           outfile ) ;
        end loop ;
        Ada.Streams.Stream_Io.Close(file) ;
    exception
        when others =>
              null ;
    end Dump ;

end hex.dump.file ;
