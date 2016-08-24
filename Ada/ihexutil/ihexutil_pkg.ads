with Interfaces ;

with Ramdesc ;

package ihexutil_pkg is
   procedure Show( filename : string ;
                   memory : boolean := false ;
		   Controller : access Ramdesc.Controller_Type := null ) ;
   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ; crcaddress : Integer ) ;
   procedure Checksum( line : string ) ;
end ihexutil_pkg ;
