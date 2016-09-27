--
-- This test program is written to explore the Output attribute of arbitrary
-- data types
--
-- usage:
-- sieve <highestno> <filename>
--
with Ada.Command_Line ;
with Text_Io; use Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io ;
with Ada.Numerics.Elementary_Functions ; use Ada.Numerics.Elementary_Functions ;
with Ada.Containers.Formal_Vectors ;
with Ada.Streams.Stream_IO ;

procedure sieve is

   highest : integer := Integer'Value( Ada.Command_Line.Argument(1) ) ;
   filename : string := Ada.Command_Line.Argument(2) ;
   type list_range is range 1..1000 ;
   package number_list_pkg is new Ada.Containers.Formal_Vectors( list_range , Integer ) ;
   primelist : number_list_pkg.Vector := number_list_pkg.Empty_Vector ;
   outfile : ada.streams.stream_io.file_type ;
   outstream : ada.streams.stream_io.stream_access ;

   procedure ListPrimes( h : integer ) is
      type boolarray is array (integer range <>) of boolean ;
      pragma pack( boolarray ) ;
      isprime : boolarray(1..highest) := (others => true) ;
      sqrtofh : integer := Integer( Sqrt(float(h)) ) ;
   begin
      for p in 2..sqrtofh
      loop
         for pp in 2..h/2
         loop
            begin
               isprime( p * pp ) := false ;
            exception
               when others => null ;
            end ;
         end loop ;
      end loop ;
      for p in 1..h
      loop
         if isprime(p)
         then
            number_list_pkg.append( primelist , p ) ;
            put(p) ;
            new_line ;
         end if ;
      end loop ;
      ada.streams.stream_io.create( outfile , name => filename ) ;
      outstream := ada.streams.stream_io.stream( outfile ) ;
      --number_list_pkg.Vector'Write( outstream , primelist ) ;
      boolarray'Output( outstream , isprime ) ;
      ada.streams.stream_io.close( outfile ) ;
   end ListPrimes ;

begin
   put("Will enumerate primes till ");
   put( highest ) ;
   new_line ;
   ListPrimes(highest) ;
end sieve ;
