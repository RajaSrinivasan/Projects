with System.Storage_Elements; use System.Storage_Elements;
with Ada.Characters.Handling;
with Ada.Text_IO;             use Ada.Text_IO;
with Ada.Integer_Text_IO;     use Ada.Integer_Text_IO;
with GNAT.Debug_Utilities;

package body Hex.dump is
   procedure Dump
     (Adr         : System.Address;
      Length      : Integer;
      show_offset : Boolean               := True;
      Blocklen    : Integer               := DEFAULT_BLOCK_LENGTH;
      Outfile     : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output)
   is
      blockadr : System.Address := Adr;
      bigBlock : array (1 .. Length) of Interfaces.Unsigned_8;
      for bigBlock'Address use Adr;

      No_Blocks    : constant Integer := Length / Blocklen + 1;
      Blockstart   : Integer;
      Lengthleft   : Integer          := Length;
      Lengthtodump : Integer;

      adrcol : Integer := 1;
      piccol : Integer := GNAT.Debug_Utilities.Address_Image_Length + adrcol;
      hexcol : Integer := piccol + Blocklen + 4;

      function CharImage (ci : Interfaces.Unsigned_8) return Character is
         c : Character := Character'Val (Integer (ci));
      begin
         if not Ada.Characters.Handling.Is_ISO_646 (c) then
            return '.';
         end if;
         if Ada.Characters.Handling.Is_Alphanumeric (c) then
            return c;
         end if;

         return '.';
      end CharImage;

   begin

      for B in 1 .. No_Blocks loop
         Blockstart := (B - 1) * Blocklen + 1;
         if show_offset then
            Put (Outfile, Blockstart-1, Base => 16);
         else
            Put (Outfile, GNAT.Debug_Utilities.Image (blockadr));
         end if;

         if Lengthleft >= Blocklen then
            Lengthtodump := Blocklen;
         else
            Lengthtodump := Lengthleft;
         end if;

         Set_Col (Outfile, Count (piccol));
         Put ("* ");
         for b in 1 .. Lengthtodump loop
            Put (CharImage (bigBlock (Blockstart + b - 1)));
         end loop;
         Set_Col (Outfile, Count (piccol + Blocklen + 3));
         Put (" * ");
         for b in 1 .. Lengthtodump loop
            Put (Hex.Image (bigBlock (Blockstart + b - 1)));
         end loop;
         Set_Col (Outfile, Count (piccol + Blocklen + 3 + Blocklen * 2 + 3));
         Put_Line (" *");
         blockadr   := blockadr + Storage_Offset (Lengthtodump);
         Lengthleft := Lengthleft - Lengthtodump;
         exit when Lengthleft = 0;
      end loop;
   end Dump;

end Hex.dump;
