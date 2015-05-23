package Zlib.Checksums is
   function Adler32
     (Adler : Interfaces.C.unsigned_long;
      Buf   : System.Address;
      Len   : Interfaces.C.int)
      return  Interfaces.C.unsigned_long;
   function Adler32_Combine
     (Adler1 : Interfaces.C.unsigned_long;
      Adler2 : Interfaces.C.unsigned_long;
      Len2   : Interfaces.C.unsigned_long)
      return   Interfaces.C.unsigned_long;
   function Crc32
     (Crc  : Interfaces.C.unsigned_long;
      Buf  : System.Address;
      Len  : Interfaces.C.unsigned_long)
      return Interfaces.C.unsigned_long;
   function Crc32_Combine
     (Crc1 : Interfaces.C.unsigned_long;
      Crc2 : Interfaces.C.unsigned_long;
      Len2 : Interfaces.C.unsigned_long)
      return Interfaces.C.unsigned_long;
private
   pragma Import (C, Adler32, "adler32");
   pragma Import (C, Adler32_Combine, "adler32_combine");
   pragma Import (C, Crc32, "crc32");
   pragma Import (C, Crc32_Combine, "crc32_combine");
end Zlib.Checksums;
