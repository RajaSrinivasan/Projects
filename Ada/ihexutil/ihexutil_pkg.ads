with Interfaces ; use Interfaces ;

with mcu ;

package ihexutil_pkg is

   -- Show the contents of the hex file
   -- Controller is required to compute the address limits for each line
   -- If no controller is provided, assumed to be a byte oriented model
   procedure Show( filename : string ;
                   Controller : access mcu.Controller_Type'Class := null ) ;

   -- Generate a new hex file with the checksum added
   procedure CopyWithCRC( infilename : string ;
                          outfilename : string ;
                          crcaddress : Unsigned_32 ;
                          Controller : not null access mcu.Controller_Type'Class ) ;

   -- Show the checksum of the line of (hex) text
   procedure Checksum( line : string ) ;

end ihexutil_pkg ;
