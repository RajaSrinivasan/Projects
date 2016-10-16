with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Strings.Fixed ; use Ada.Strings.Fixed ;

with Ada.Long_Integer_Text_Io; use Ada.Long_Integer_Text_Io;

with Interfaces ; use Interfaces ;

with gnat.strings ; use gnat.strings ;


with hex ; use hex ;
with ihbr ; use ihbr ;

with ihexutil_cli ;                            -- [cli/$_cli]
with ihexutil_pkg ;
with Ramdesc ;
with ramdesc.pmd ;
with ramdesc.ahpepmpbm ;

with mcu ;
with mcu.tms320 ;
with mcu.msc1210 ;

procedure ihexutil is                  -- [clitest/$]
   Controller : access Ramdesc.Controller_Type ;
begin
   ihexutil_cli.ProcessCommandLine ;           -- [cli/$_cli]
   declare
      arg : String := ihexutil_cli.GetNextArgument;
   begin
      if ihexutil_cli.Verbose
      then
         ihexutil_cli.ShowArguments ;
      end if ;
      if ihexutil_cli.mcuspec /= null
      then
         declare
            mcuname, mcutype : unbounded_string ;
            sep : integer; 
         begin
            sep := index( ihexutil_cli.mcuspec.all , ":" ) ;
            if sep = 0
            then
               put_line("MCU spec should be name:type") ;
               raise Program_Error ;
            end if ;
            mcuname := to_unbounded_string( head( ihexutil_cli.mcuspec.all , sep - 1 ) ) ;
            mcutype := to_unbounded_string( tail( ihexutil_cli.mcuspec.all , sep + 1 ) ) ;
            put("MCU Type : ") ; put_line( to_string(mcutype) ) ;
            put("MCU Name : ") ; put_line( to_string(mcuname) ) ;
         end ;
         
      end if ;
      
      if Ihexutil_Cli.Ramname /= null
      then
	 if Ihexutil_Cli.Ramname.all = "PMD"
	 then
	    Controller := Ramdesc.pmd.DSPPMD'Access ;
	 else
	    Controller := Ramdesc.ahpepmpbm.MCUAHPEPMPBM'Access ; 
	 end if ;
      end if ;
      
      if ihexutil_cli.showoption
      then
         ihexutil_Pkg.Show( arg , ihexutil_cli.memoryoption , Controller ) ;
      elsif ihexutil_cli.hexline /= null_unbounded_string
      then
         ihexutil_Pkg.Checksum( to_string( ihexutil_cli.hexline ) ) ;
      elsif ihexutil_cli.addcrcaddress > 0
      then
          if ihexutil_cli.outputname = null
          then
             Put_Line("Need an output file name to generate CRC") ;
             return ;
         end if ;
         ihexutil_pkg.CopyWithCRC( arg , ihexutil_cli.outputname.all , ihexutil_cli.addcrcaddress ) ;
      end if ;
   end ;
   
end ihexutil ;                         -- [clitest/$]
