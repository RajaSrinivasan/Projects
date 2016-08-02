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
  
  PMD : Flashram_Type(1..5) := ( 
                            ( to_unbounded_string("SECTORA") , 16#003f_6000# , 16#1ff8# ) ,
                            ( to_unbounded_string("SECTORB") , 16#003f_4000# , 16#2000# ) , 
                            ( to_unbounded_string("SECTORC") , 16#003f_0000# , 16#4000# ) ,
                            ( to_unbounded_string("SECTORD") , 16#003e_c000# , 16#4000# ) ,
                            ( to_unbounded_string("SECTORE") , 16#003e_8000# , 16#4000# ) ) ;
  DSPPMD : aliased Controller_Type := ( To_Unbounded_String("PMD") , null ) ;
  
  AHPEPMPBM : Flashram_type(1..2) := (
                            ( to_unbounded_string("DATA")    , 16#0400# , 16#0400# ) ,
				 ( to_unbounded_string("PROGRAM") , 16#0000# , 16#73fd# ) ) ; 
  MCUAHPEPMPBM : aliased Controller_Type := ( To_Unbounded_String("AHPEPMPBM") , null ) ;
  
  procedure Show( ram : ram_type ) ;
  procedure Show( Flashram : Flashram_Ptr_Type ) ;
  procedure Show( Controller : Controller_Type ) ;
  
end ramdesc ;
