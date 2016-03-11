with System;
with Interfaces.C;
with Interfaces.C.Strings;

package Zlib is
   pragma Linker_Options ("-lz");
   V : constant String := "1.2.3";
   type Level_Type is
     (DEFAULT_COMPRESSION, NO_COMPRESSION, BEST_SPEED, BEST_COMPRESSION);
   for Level_Type use
   (DEFAULT_COMPRESSION => -1,
    NO_COMPRESSION      => 0,
    BEST_SPEED          => 1,
    BEST_COMPRESSION    => 9);
   for Level_Type'Size use Interfaces.C.int'Size;
   pragma Convention (C, Level_Type);

   type Strategy_Type is (DEFAULT, FILTERED, HUFFMAN_ONLY, RLE, FIXED);
   for Strategy_Type use
   (FILTERED     => 1,
    HUFFMAN_ONLY => 2,
    RLE          => 3,
    FIXED        => 4,
    DEFAULT      => 0);
   for Strategy_Type'Size use Interfaces.C.int'Size;
   pragma Convention (C, Strategy_Type);

   type DataType is (BINARY, TEXT, UNKNOWN);
   for DataType use (BINARY => 0, TEXT => 1, UNKNOWN => 2);
   for DataType'Size use Interfaces.C.int'Size;
   pragma Convention (C, DataType);

   type Returncodes is
     (Version_Error,
      Buf_Error,
      Mem_Error,
      Data_Error,
      Stream_Error,
      Errno,
      Ok,
      Stream_End,
      Need_Dict);
   for Returncodes use
   (Version_Error => -6,
    Buf_Error     => -5,
    Mem_Error     => -4,
    Data_Error    => -3,
    Stream_Error  => -2,
    Errno         => -1,
    Ok            => 0,
    Stream_End    => 1,
    Need_Dict     => 2);
   for Returncodes'Size use Interfaces.C.int'Size;
   pragma Convention (C, Returncodes);

   ----------------------------------------------------------
   function Version return Interfaces.C.Strings.chars_ptr;
   function Error
     (Num : Interfaces.C.int) return Interfaces.C.Strings.chars_ptr;
   ----------------------------------------------------------
private
   pragma Import (C, Version, "zlibVersion");
   pragma Import (C, Error, "zError");
end Zlib;
