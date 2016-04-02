pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with System;


package bzlib is

   BZ_RUN : constant := 0 ;
   BZ_FLUSH  : constant := 1 ;
   BZ_FINISH  : constant := 2 ;
     
   BZ_OK  : constant := 0 ;
   BZ_RUN_OK  : constant := 1 ;
   BZ_FLUSH_OK  : constant := 2 ;
   BZ_FINISH_OK  : constant := 3 ;
   BZ_STREAM_END  : constant := 4 ;
   BZ_SEQUENCE_ERROR  : constant := (-1) ;
   BZ_PARAM_ERROR  : constant := (-2) ;
   BZ_MEM_ERROR  : constant := (-3) ;
   BZ_DATA_ERROR  : constant := (-4) ;
   BZ_DATA_ERROR_MAGIC  : constant := (-5) ;
   BZ_IO_ERROR  : constant := (-6) ;
   BZ_UNEXPECTED_EOF  : constant := (-7) ;
   BZ_OUTBUFF_FULL  : constant := (-8) ;
   BZ_CONFIG_ERROR  : constant := (-9) ;
     
   --  arg-macro: procedure BZ_API (func)
   --    func
   --  unsupported macro: BZ_EXTERN extern
   --  unsupported macro: BZ_MAX_UNUSED 5000
  --------------------------------------------------------------- 
  ----- Public header file for the library.                   --- 
  -----                                               bzlib.h --- 
  --------------------------------------------------------------- 
  -- ------------------------------------------------------------------
  --   This file is part of bzip2/libbzip2, a program and library for
  --   lossless, block-sorting data compression.
  --   bzip2/libbzip2 version 1.0.6 of 6 September 2010
  --   Copyright (C) 1996-2010 Julian Seward <jseward@bzip.org>
  --   Please read the WARNING, DISCLAIMER and PATENTS sections in the 
  --   README file.
  --   This program is released under the terms of the license contained
  --   in the file LICENSE.
  --   ------------------------------------------------------------------  

   type bz_stream is record
      next_in : Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/bzlib.h:50
      avail_in : aliased unsigned;  -- /usr/local/include/bzlib.h:51
      total_in_lo32 : aliased unsigned;  -- /usr/local/include/bzlib.h:52
      total_in_hi32 : aliased unsigned;  -- /usr/local/include/bzlib.h:53
      next_out : Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/bzlib.h:55
      avail_out : aliased unsigned;  -- /usr/local/include/bzlib.h:56
      total_out_lo32 : aliased unsigned;  -- /usr/local/include/bzlib.h:57
      total_out_hi32 : aliased unsigned;  -- /usr/local/include/bzlib.h:58
      state : System.Address;  -- /usr/local/include/bzlib.h:60
      bzalloc : access function
           (arg1 : System.Address;
            arg2 : int;
            arg3 : int) return System.Address;  -- /usr/local/include/bzlib.h:62
      bzfree : access procedure (arg1 : System.Address; arg2 : System.Address);  -- /usr/local/include/bzlib.h:63
      opaque : System.Address;  -- /usr/local/include/bzlib.h:64
   end record;
   pragma Convention (C_Pass_By_Copy, bz_stream);  -- /usr/local/include/bzlib.h:66

  -- Need a definitition for FILE  
  -- windows.h define small to char  
  -- import windows dll dynamically  
  ---- Core (low-level) library functions -- 
   function BZ2_bzCompressInit
     (arg1 : access bz_stream;
      arg2 : int;
      arg3 : int;
      arg4 : int) return int;  -- /usr/local/include/bzlib.h:100
   pragma Import (C, BZ2_bzCompressInit, "BZ2_bzCompressInit");

   function BZ2_bzCompress (arg1 : access bz_stream; arg2 : int) return int;  -- /usr/local/include/bzlib.h:107
   pragma Import (C, BZ2_bzCompress, "BZ2_bzCompress");

   function BZ2_bzCompressEnd (arg1 : access bz_stream) return int;  -- /usr/local/include/bzlib.h:112
   pragma Import (C, BZ2_bzCompressEnd, "BZ2_bzCompressEnd");

   function BZ2_bzDecompressInit
     (arg1 : access bz_stream;
      arg2 : int;
      arg3 : int) return int;  -- /usr/local/include/bzlib.h:116
   pragma Import (C, BZ2_bzDecompressInit, "BZ2_bzDecompressInit");

   function BZ2_bzDecompress (arg1 : access bz_stream) return int;  -- /usr/local/include/bzlib.h:122
   pragma Import (C, BZ2_bzDecompress, "BZ2_bzDecompress");

   function BZ2_bzDecompressEnd (arg1 : access bz_stream) return int;  -- /usr/local/include/bzlib.h:126
   pragma Import (C, BZ2_bzDecompressEnd, "BZ2_bzDecompressEnd");

  ---- High(er) level library functions -- 
   subtype BZFILE is System.Address;  -- /usr/local/include/bzlib.h:137

   function BZ2_bzReadOpen
     (arg1 : access int;
      arg2 : access stdio_h.FILE;
      arg3 : int;
      arg4 : int;
      arg5 : System.Address;
      arg6 : int) return System.Address;  -- /usr/local/include/bzlib.h:139
   pragma Import (C, BZ2_bzReadOpen, "BZ2_bzReadOpen");

   procedure BZ2_bzReadClose (arg1 : access int; arg2 : System.Address);  -- /usr/local/include/bzlib.h:148
   pragma Import (C, BZ2_bzReadClose, "BZ2_bzReadClose");

   procedure BZ2_bzReadGetUnused
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : System.Address;
      arg4 : access int);  -- /usr/local/include/bzlib.h:153
   pragma Import (C, BZ2_bzReadGetUnused, "BZ2_bzReadGetUnused");

   function BZ2_bzRead
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : System.Address;
      arg4 : int) return int;  -- /usr/local/include/bzlib.h:160
   pragma Import (C, BZ2_bzRead, "BZ2_bzRead");

   function BZ2_bzWriteOpen
     (arg1 : access int;
      arg2 : access stdio_h.FILE;
      arg3 : int;
      arg4 : int;
      arg5 : int) return System.Address;  -- /usr/local/include/bzlib.h:167
   pragma Import (C, BZ2_bzWriteOpen, "BZ2_bzWriteOpen");

   procedure BZ2_bzWrite
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : System.Address;
      arg4 : int);  -- /usr/local/include/bzlib.h:175
   pragma Import (C, BZ2_bzWrite, "BZ2_bzWrite");

   procedure BZ2_bzWriteClose
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : int;
      arg4 : access unsigned;
      arg5 : access unsigned);  -- /usr/local/include/bzlib.h:182
   pragma Import (C, BZ2_bzWriteClose, "BZ2_bzWriteClose");

   procedure BZ2_bzWriteClose64
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : int;
      arg4 : access unsigned;
      arg5 : access unsigned;
      arg6 : access unsigned;
      arg7 : access unsigned);  -- /usr/local/include/bzlib.h:190
   pragma Import (C, BZ2_bzWriteClose64, "BZ2_bzWriteClose64");

  ---- Utility functions -- 
   function BZ2_bzBuffToBuffCompress
     (arg1 : Interfaces.C.Strings.chars_ptr;
      arg2 : access unsigned;
      arg3 : Interfaces.C.Strings.chars_ptr;
      arg4 : unsigned;
      arg5 : int;
      arg6 : int;
      arg7 : int) return int;  -- /usr/local/include/bzlib.h:204
   pragma Import (C, BZ2_bzBuffToBuffCompress, "BZ2_bzBuffToBuffCompress");

   function BZ2_bzBuffToBuffDecompress
     (arg1 : Interfaces.C.Strings.chars_ptr;
      arg2 : access unsigned;
      arg3 : Interfaces.C.Strings.chars_ptr;
      arg4 : unsigned;
      arg5 : int;
      arg6 : int) return int;  -- /usr/local/include/bzlib.h:214
   pragma Import (C, BZ2_bzBuffToBuffDecompress, "BZ2_bzBuffToBuffDecompress");

  ----
  --   Code contributed by Yoshioka Tsuneo (tsuneo@rr.iij4u.or.jp)
  --   to support better zlib compatibility.
  --   This code is not _officially_ part of libbzip2 (yet);
  --   I haven't tested it, documented it, or considered the
  --   threading-safeness of it.
  --   If this code breaks, please contact both Yoshioka and me.
  ---- 

   function BZ2_bzlibVersion return Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/bzlib.h:233
   pragma Import (C, BZ2_bzlibVersion, "BZ2_bzlibVersion");

   function BZ2_bzopen (arg1 : Interfaces.C.Strings.chars_ptr; arg2 : Interfaces.C.Strings.chars_ptr) return System.Address;  -- /usr/local/include/bzlib.h:238
   pragma Import (C, BZ2_bzopen, "BZ2_bzopen");

   function BZ2_bzdopen (arg1 : int; arg2 : Interfaces.C.Strings.chars_ptr) return System.Address;  -- /usr/local/include/bzlib.h:243
   pragma Import (C, BZ2_bzdopen, "BZ2_bzdopen");

   function BZ2_Bzread_alt
     (arg1 : System.Address;
      arg2 : System.Address;
      arg3 : int) return int;  -- /usr/local/include/bzlib.h:248
   pragma Import (C, BZ2_Bzread_alt, "BZ2_bzread");

   function BZ2_Bzwrite_alt
     (arg1 : System.Address;
      arg2 : System.Address;
      arg3 : int) return int;  -- /usr/local/include/bzlib.h:254
   pragma Import (C, BZ2_Bzwrite_alt, "BZ2_bzwrite");

   function BZ2_bzflush (arg1 : System.Address) return int;  -- /usr/local/include/bzlib.h:260
   pragma Import (C, BZ2_bzflush, "BZ2_bzflush");

   procedure BZ2_bzclose (arg1 : System.Address);  -- /usr/local/include/bzlib.h:264
   pragma Import (C, BZ2_bzclose, "BZ2_bzclose");

   function BZ2_bzerror (arg1 : System.Address; arg2 : access int) return Interfaces.C.Strings.chars_ptr;  -- /usr/local/include/bzlib.h:268
   pragma Import (C, BZ2_bzerror, "BZ2_bzerror");

  --------------------------------------------------------------- 
  ----- end                                           bzlib.h --- 
  --------------------------------------------------------------- 
end Bzlib ;
