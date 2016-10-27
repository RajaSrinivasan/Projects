with Interfaces ;

with mcu ;

package ihexutil_pkg is
   procedure Show( filename : string ;
		   Controller : access mcu.Controller_Type'Class := null ) ;
   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ; crcaddress : Integer ) ;
   procedure Checksum( line : string ) ;
end ihexutil_pkg ;
