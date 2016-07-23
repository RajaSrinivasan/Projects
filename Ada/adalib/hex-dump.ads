with System;
with Ada.Text_IO;

package Hex.dump is

   DEFAULT_BLOCK_LENGTH : constant Integer := 32;
   function CharImage (ci : Interfaces.Unsigned_8) return Character ;
   procedure Dump
     (Adr         : System.Address;
      Length      : Integer;
      show_offset : Boolean               := True;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

end Hex.dump;
