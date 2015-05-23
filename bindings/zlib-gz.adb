with System; use System;
package body Zlib.Gz is
   function Gzopen
     (Path : Interfaces.C.char_array;
      Mode : Interfaces.C.char_array)
      return System.Address;
   pragma Import (C, Gzopen, "gzopen");
   function Gzdopen
     (Fd   : Interfaces.C.int;
      Mode : Interfaces.C.char_array)
      return System.Address;
   pragma Import (C, Gzdopen, "gzdopen");

   function Gzclose (Gzfile : System.Address) return Returncodes;
   pragma Import (C, Gzclose, "gzclose");

   function Open (Path : String; Mode : String) return File_Type is
      File : System.Address;
   -- use type System.Address ;
   begin
      File := Gzopen (Interfaces.C.To_C (Path), Interfaces.C.To_C (Mode));
      if File = System.Null_Address then
         raise Program_Error;
      end if;
      return File_Type (File);
   end Open;
   function DOpen (Fd : Interfaces.C.int; Mode : String) return File_Type is
      File : System.Address;
   begin
      File := Gzdopen (Fd, Interfaces.C.To_C (Mode));
      if File = System.Null_Address then
         raise Program_Error;
      end if;
      return File_Type (File);
   end DOpen;

   procedure Close (File : in out File_Type; Status : out Returncodes) is

   begin
      Status := Gzclose (System.Address (File));
      File   := File_Type (System.Null_Address);
   end Close;

end Zlib.Gz;
