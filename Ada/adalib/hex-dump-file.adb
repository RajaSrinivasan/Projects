with Ada.Streams.Stream_IO;

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
         Hex.dump.Dump
           (buffer'Address,
            Integer (bufferlen),
            show_offset,
            Blocklen,
            Outfile);
      end loop;
      Ada.Streams.Stream_IO.Close (file);
   exception
      when others =>
         null;
   end Dump;

end Hex.dump.file;
