package Zlib.Gz is
   type File_Type is private;
   function Open (Path : String; Mode : String) return File_Type;
   function DOpen (Fd : Interfaces.C.int; Mode : String) return File_Type;
   procedure Close (File : in out File_Type; Status : out Returncodes);
   function Setparams
     (File     : File_Type;
      Level    : Level_Type;
      Strategy : Strategy_Type)
      return     Returncodes;
   function Read
     (Gzfile : File_Type;
      Buf    : System.Address;
      Len    : Interfaces.C.unsigned_long)
      return   Interfaces.C.int;
   function Write
     (Gzfile : File_Type;
      Buf    : System.Address;
      Len    : Interfaces.C.unsigned_long)
      return   Interfaces.C.int;
private
   type File_Type is new System.Address;
   pragma Import (C, Setparams, "gzsetparams");
   pragma Import (C, Read, "gzread");
   pragma Import (C, Write, "gzwrite");
end Zlib.Gz;
