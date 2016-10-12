with Text_Io ; use Text_Io ;
with Ramdesc ;
with Ramdesc.pmd ;
with ramdesc.ahpepmpbm ;

with mcu ;
with mcu.tms320 ;

procedure Ramdesctest is

begin
   Ramdesc.Show( Ramdesc.pmd.DSPPMD ) ;
   Ramdesc.Show( Ramdesc.ahpepmpbm.MCUAHPEPMPBM ) ;
   declare
      mcupmd : aliased mcu.tms320.f2810_Type ;
   begin
      mcupmd := mcu.tms320.f2810_type(mcu.Create("PMD"));
      mcu.Show(mcupmd'access) ;
   end ;

end Ramdesctest ;
