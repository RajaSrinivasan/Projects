with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
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

procedure ihexutil is                  -- [clitest/$]
   Controller : access Ramdesc.Controller_Type ;
begin
   ihexutil_cli.ProcessCommandLine ;           -- [cli/$_cli]
   declare
      arg : String := ihexutil_cli.GetNextArgument;
   begin
      if ihexutil_cli.Verbose
      then
         Put_Line("-----------------------------------------------------------") ;
         Put("Show Option : ") ;
         Put_Line(boolean'image(ihexutil_cli.showoption)) ;
         Put("Memory Option : ");
	 Put_Line(boolean'image(ihexutil_cli.memoryoption)) ;
         Put("Hex File    : ") ;
         Put_Line(arg) ;
         Put("Hex Line    : ") ;
         Put_Line(to_string( ihexutil_cli.hexline )) ;
         Put("Add crc @   : ") ;
         Put(ihexutil_cli.addcrcaddress) ;
         new_line ;
         Put("Output File : ");
         Put_Line(ihexutil_cli.outputname.all);
         Put("RAM section name : ") ;
         if ihexutil_cli.ramname = null
         then
            Put_Line("Not specified");
         else
            Put_Line( ihexutil_cli.ramname.all ) ;
         end if ;
         Put("Word Length : ") ;
         Put( ihexutil_cli.wordlength ) ;
         New_Line ;
         Put_Line("-----------------------------------------------------------") ;
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
