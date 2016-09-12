with Interfaces ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
package ramdesc is

  type sector_type is
       record
          name : unbounded_string ;
          start : Interfaces.Unsigned_32 ;
          length : Interfaces.Unsigned_16 ;
       end record ;

  type ram_type is array (integer range <>) of sector_type ;
  type flashram_type is array (integer range <>) of sector_type ;
  type Flashram_Ptr_Type is access all Flashram_Type ;
  
  type Controller_Type is
     record
	Name : Unbounded_String ;
	Flash : Flashram_Ptr_Type ;
     end record ;
  
  procedure Show( ram : ram_type ) ;
  procedure Show( Flashram : Flashram_Ptr_Type ) ;
  procedure Show( Controller : Controller_Type ) ;
  
end ramdesc ;
