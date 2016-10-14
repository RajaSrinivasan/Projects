with Text_Io ; use Text_Io ;
with Ramdesc ;
with Ramdesc.pmd ;
with ramdesc.ahpepmpbm ;

with mcu ;
with mcu.tms320 ;
with mcu.msc1210 ;

procedure Ramdesctest is

begin
   Ramdesc.Show( Ramdesc.pmd.DSPPMD ) ;
   Ramdesc.Show( Ramdesc.ahpepmpbm.MCUAHPEPMPBM ) ;
   declare
      mcupmd : aliased mcu.tms320.f2810_Type ;
      mcuahp : aliased mcu.msc1210.msc1210_Type ;
   begin
      mcupmd := mcu.tms320.f2810_type(mcu.Create( "PMD" , mcu.tms320.mcutype_f2810 ));
      mcu.Show(mcupmd'access) ;
      mcuahp := mcu.msc1210.msc1210_Type( mcu.Create("AHP" , mcu.msc1210.mcutype_msc1210 ) ) ;
      mcu.Show( mcuahp'access ) ;
   end ;

end Ramdesctest ;
