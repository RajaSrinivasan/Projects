package ramdesc.pmd is
  PMD : Flashram_Type(1..5) := (
                            ( to_unbounded_string("SECTORA") , 16#003f_6000# , 16#1ff8# ) ,
                            ( to_unbounded_string("SECTORB") , 16#003f_4000# , 16#2000# ) ,
                            ( to_unbounded_string("SECTORC") , 16#003f_0000# , 16#4000# ) ,
                            ( to_unbounded_string("SECTORD") , 16#003e_c000# , 16#4000# ) ,
                            ( to_unbounded_string("SECTORE") , 16#003e_8000# , 16#4000# ) ) ;
  DSPPMD : aliased Controller_Type := ( To_Unbounded_String("PMD") , null ) ;
end ramdesc.pmd ;
