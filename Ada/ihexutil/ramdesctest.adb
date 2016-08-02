with Text_Io ; use Text_Io ;
with Ramdesc ;

procedure Ramdesctest is
begin
   Put_Line("PMD");
   Ramdesc.Show( Ramdesc.PMD ) ;
   Put_Line("AHPEPMPBM");
   Ramdesc.Show( Ramdesc.AHPEPMPBM ) ;
end Ramdesctest ;
