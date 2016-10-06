with Text_Io ; use Text_Io ;
with Ramdesc ;
with Ramdesc.pmd ;
with ramdesc.ahpepmpbm ;

procedure Ramdesctest is
begin
   Ramdesc.Show( Ramdesc.pmd.DSPPMD ) ;
   Ramdesc.Show( Ramdesc.ahpepmpbm.MCUAHPEPMPBM ) ;
end Ramdesctest ;
