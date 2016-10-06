package ramdesc.ahpepmpbm is

  AHPEPMPBM : constant Flashram_type(1..2) := (
                                 ( to_unbounded_string("DATA")    , 16#0400# , 16#0400# ) ,
				 ( to_unbounded_string("PROGRAM") , 16#0000# , 16#73fd# ) ) ;
  MCUAHPEPMPBM : aliased Controller_Type := ( To_Unbounded_String("AHPEPMPBM") , null ) ;
private
   procedure Initialize ;
end ramdesc.ahpepmpbm ;
