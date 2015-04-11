with system.Storage_Elements ; use system.Storage_Elements ;
with ada.Characters.handling ;
with ada.text_io; use ada.text_io ;
with gnat.Debug_Utilities ;

package body hex.dump is
   procedure Dump
     (Adr     : System.Address;
      Length  : Integer;
      Offset : Integer := 0;
      show_offset : boolean := true ;
      Blocklen : Integer := DEFAULT_BLOCK_LENGTH;
      Outfile : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output)
   is
      blockadr : system.address := adr ;
      bigBlock :
        array (1 .. Length) of interfaces.unsigned_8 ;
      for bigBlock'Address use Adr;

      No_Blocks : constant Integer := Length / Blocklen + 1;
      Blockstart : Integer;
      Lengthleft : Integer := Length;
      Lengthtodump : Integer;

      adrcol : integer := 1 ;
      piccol : integer := gnat.Debug_Utilities.Address_Image_Length + adrcol ;
      hexcol : integer := piccol + blocklen + 4 ;

      function CharImage(ci : interfaces.unsigned_8) return Character is
         c : character := character'val( integer(ci) ) ;
      begin
         if Ada.Characters.Handling.Is_Graphic( c )
         then
            return c ;
         end if ;
         return '.' ;
      end CharImage ;

   begin
      new_line ;
      if show_offset
      then
         put( Image( interfaces.unsigned_32(offset) )) ;
      else
         put( Outfile , gnat.Debug_Utilities.Image( blockadr )) ;
      end if ;

      for B in 1 .. No_Blocks
      loop
         Blockstart := (B - 1) * Blocklen + 1;
         if Lengthleft > Blocklen then
            Lengthtodump := Blocklen ;
         else
            Lengthtodump := Lengthleft ;
         end if;

         Set_Col(OutFile , Count(piccol)) ;
         put("* ");
         for b in 1..Lengthtodump
         loop
            put(CharImage(bigBlock(blockstart+b-1)));
         end loop ;
         put(" * ");
         for b in 1..lengthtodump
         loop
            put( hex.image(bigBlock(blockstart+b-1)) ) ;
         end loop ;
         put_line(" *");
         blockadr := blockadr + storage_offset(lengthtodump) ;
         Lengthleft := Lengthleft - Lengthtodump;
         exit when Lengthleft = 0;
      end loop;
   end Dump;

end hex.dump;
