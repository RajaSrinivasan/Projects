package Zlib.Utilities is
   subtype Bytep is System.Address;
   type Ulongp is access all Interfaces.C.unsigned_long;
   pragma Convention (C, Ulongp);
   function Compress
     (Dest      : Bytep;
      Destlen   : Ulongp;
      Source    : Bytep;
      Sourcelen : Interfaces.C.unsigned_long)
      return      Returncodes;
   function Compress2
     (Dest      : Bytep;
      Destlen   : Ulongp;
      Source    : Bytep;
      Sourcelen : Interfaces.C.unsigned_long;
      Level     : Interfaces.C.int)
      return      Returncodes;
   function CompressBound
     (Sourcelen : Interfaces.C.unsigned_long)
      return      Returncodes;
   function Uncompress
     (Dest      : Bytep;
      Destlen   : Ulongp;
      Source    : Bytep;
      Sourcelen : Interfaces.C.unsigned_long)
      return      Returncodes;
private
   pragma Import (C, Compress, "compress");
   pragma Import (C, Compress2, "compress2");
   pragma Import (C, CompressBound, "compressBound");
   pragma Import (C, Uncompress, "uncompress");
end Zlib.Utilities;
