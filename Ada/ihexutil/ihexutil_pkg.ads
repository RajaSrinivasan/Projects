with Interfaces ;
package ihexutil_pkg is
   procedure Show( filename : string ) ;
   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ; crcaddress : Integer ) ;
   procedure Checksum( line : string ) ;
end ihexutil_pkg ;
