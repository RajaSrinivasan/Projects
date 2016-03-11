with System;
with System.Storage_Elements;
with Interfaces;

package crc16 is

   type block_type is array (Integer range <>) of Interfaces.Unsigned_8;

   pragma Pack (block_type);

   procedure Update
     (Oldvalue :     Interfaces.Unsigned_16;
      Blockptr :     System.Address;
      Blocklen :     Integer;
      Newvalue : out Interfaces.Unsigned_16);
   function Compute
     (Blockptr : System.Address;
      blocklen : Integer) return Interfaces.Unsigned_16;

   procedure Update
     (Oldvalue :     Interfaces.Unsigned_16;
      Block    :     block_type;
      Newvalue : out Interfaces.Unsigned_16);
   procedure Update
     (crcvalue : in out Interfaces.Unsigned_16;
      block    :        System.Storage_Elements.Storage_Array);
   procedure Selftest;
end crc16;
