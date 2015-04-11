with system ;
with ada.text_io ;

package hex.dump is

   DEFAULT_BLOCK_LENGTH : constant Integer := 32 ;

   procedure Dump
     (Adr     : System.Address;
      Length  : Integer;
      show_offset : boolean := true ;
      Blocklen : Integer := DEFAULT_BLOCK_LENGTH;
      Outfile : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

end hex.dump ;
