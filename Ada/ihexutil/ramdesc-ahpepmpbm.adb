package body ramdesc.ahpepmpbm is
   procedure Initialize is
   begin
      MCUAHPEPMPBM.Flash := new Flashram_Type( AHPEPMPBM'Range ) ;
      MCUAHPEPMPBM.Flash.all := AHPEPMPBM ;
   end Initialize ;
begin
   Initialize ;
end ramdesc.ahpepmpbm ;
