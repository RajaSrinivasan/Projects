pragma Ada_2005;
pragma Style_Checks (Off);

with Interfaces.C; use Interfaces.C;
with Interfaces.C.Strings;
with Interfaces.C_Streams ;

with System;


package bzlib is

   type action_type is new int ;
   BZ_RUN : constant action_type := 0 ;
   BZ_FLUSH  : constant action_type := 1 ;
   BZ_FINISH  : constant action_type:= 2 ;

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
      opaque : System.Address := System.Null_Address ;  -- /usr/local/include/bzlib.h:64
   end record;
   pragma Convention (C_Pass_By_Copy, bz_stream);  -- /usr/local/include/bzlib.h:66
   subtype verbosity_level is int range 0..4 ;
   subtype blockSize_Type is int range 0..9 ;
   subtype workFactor_Type is int range 0..250 ;
   function CompressInit
     (stream : access bz_stream;
      blockSize100k : blockSize_Type ;
      verbosity : verbosity_level ;
      workFactor : workFactor_Type ) return int;  -- /usr/local/include/bzlib.h:100
   pragma Import (C, CompressInit, "BZ2_bzCompressInit");

   function Compress (stream : access bz_stream;
                            action : action_type ) return int;  -- /usr/local/include/bzlib.h:107
   pragma Import (C, Compress, "BZ2_bzCompress");

   function CompressEnd (arg1 : access bz_stream) return int;  -- /usr/local/include/bzlib.h:112
   pragma Import (C, CompressEnd, "BZ2_bzCompressEnd");

   function DecompressInit
     (stream : access bz_stream;
      verbosity : verbosity_level ;
      small : int) return int;  -- /usr/local/include/bzlib.h:116
   pragma Import (C, DecompressInit, "BZ2_bzDecompressInit");

   function Decompress (stream : access bz_stream) return int;  -- /usr/local/include/bzlib.h:122
   pragma Import (C, Decompress, "BZ2_bzDecompress");

   function DecompressEnd (stream : access bz_stream) return int;  -- /usr/local/include/bzlib.h:126
   pragma Import (C, DecompressEnd, "BZ2_bzDecompressEnd");

  ---- High(er) level library functions --
   subtype BZFILE is System.Address ;  -- /usr/local/include/bzlib.h:137

   function ReadOpen
     (bzerror : access int;
      f : Interfaces.C_Streams.FILEs ;
      verbosity : verbosity_level ;
      small : int;
      unused_1 : int := 0 ;
      unused_2 : int := 0 ) return BZFILE ;  -- /usr/local/include/bzlib.h:139
   pragma Import (C, ReadOpen, "BZ2_bzReadOpen");

   procedure ReadClose (arg1 : access int; arg2 : System.Address);  -- /usr/local/include/bzlib.h:148
   pragma Import (C, ReadClose, "BZ2_bzReadClose");

   procedure BZ2_bzReadGetUnused
     (arg1 : access int;
      arg2 : System.Address;
      arg3 : System.Address;
      arg4 : access int);  -- /usr/local/include/bzlib.h:153
   pragma Import (C, BZ2_bzReadGetUnused, "BZ2_bzReadGetUnused");

   function Read
     (bzerror : access int;
      b : BZFILE ;
      buf : System.Address;
      len : int) return int;  -- /usr/local/include/bzlib.h:160
   pragma Import (C, Read, "BZ2_bzRead");

   function BZ2_bzWriteOpen
     (bzerror : access int;
      f : access Interfaces.C_Streams.FILEs ;
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
