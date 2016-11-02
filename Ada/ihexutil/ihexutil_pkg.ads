with Interfaces ;

with mcu ;

package ihexutil_pkg is
   procedure Show( filename : string ;
                   Controller : access mcu.Controller_Type'Class := null ) ;

   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ;
                          crcaddress : Integer ;
                          Controller : not null access mcu.Controller_Type'Class ) ;

   procedure Checksum( line : string ) ;
end ihexutil_pkg ;
