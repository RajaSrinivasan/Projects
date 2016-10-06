package body ramdesc.pmd is
   procedure Initialize is
   begin
      DSPPMD.Flash := new Flashram_Type( PMD'Range ) ;
      DSPPMD.Flash.all := PMD ;
   end Initialize ;
begin
   Initialize ;
end ramdesc.pmd ;
