with Ada.Streams.Stream_IO;
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;

package body Hex.dump.file is
   procedure Dump
     (filename    : String;
      show_offset : Boolean               := True;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output)
   is

      use Ada.Streams;
      file   : Ada.Streams.Stream_IO.File_Type;
      stream : Ada.Streams.Stream_IO.Stream_Access;

      buffer : Ada.Streams
        .Stream_Element_Array
      (1 .. Ada.Streams.Stream_Element_Offset (Blocklen));
      bufferlen : Ada.Streams.Stream_Element_Offset;
      Offset : Natural := 0 ;
   begin
      Ada.Text_IO.Put (Outfile, "* Dump of *********");
      Ada.Text_IO.Put (Outfile, filename);
      Ada.Text_IO.Put_Line (Outfile, "*********************************");
      Ada.Streams.Stream_IO.Open
        (file,
         Ada.Streams.Stream_IO.In_File,
         filename);
      stream := Ada.Streams.Stream_IO.Stream (file);
      loop
         stream.Read (buffer, bufferlen);
         if bufferlen = 0 then
            exit;
         end if;
         Put(Item => Offset, Base => 16 , Width => 16 , File => Outfile ) ;
         Put(Item => ": " , File => Outfile );
         Hex.dump.Dump
           (buffer'Address,
            Integer (bufferlen),
            False ,
            Blocklen,
            Outfile);
         Offset := Offset + integer(bufferlen) ;
      end loop;
      Ada.Streams.Stream_IO.Close (file);
   exception
      when others =>
         Put("Exception while dumping ");
         Put_Line(filename);
   end Dump;

end Hex.dump.file;
