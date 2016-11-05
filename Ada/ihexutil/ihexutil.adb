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


with mcu ;
with mcu.tms320 ;
with mcu.msc1210 ;

procedure ihexutil is                  -- [clitest/$]   
begin
   ihexutil_cli.ProcessCommandLine ;           -- [cli/$_cli]
   declare
      arg : String := ihexutil_cli.GetNextArgument;
   begin
      if ihexutil_cli.Verbose
      then
         ihexutil_cli.ShowArguments ;
      end if ;
      
      if ihexutil_cli.mcutype /= null_unbounded_string
      then            
         declare
            ctrl : aliased mcu.Controller_Type'Class := mcu.Create( ihexutil_cli.mcuname , 
                                                            ihexutil_cli.mcutype ) ;
         begin
            if ihexutil_cli.showoption
            then
               ihexutil_pkg.Show( arg , ctrl'access ) ;
            else
               if ihexutil_cli.addcrcaddress > 0
               then
                  if ihexutil_cli.outputname = null
                  then
                     Put_Line("Need an output file name to generate CRC") ;
                     return ;
                  end if ;
                  ihexutil_pkg.CopyWithCRC( arg , ihexutil_cli.outputname.all , Unsigned_32(ihexutil_cli.addcrcaddress) ,
                                           ctrl'access ) ;
               end if ;
            end if ;
         end ;  
      else
         if ihexutil_cli.showoption
         then
            ihexutil_pkg.Show( arg ) ;      
         elsif ihexutil_cli.hexline /= null_unbounded_string
         then
            ihexutil_Pkg.Checksum( to_string( ihexutil_cli.hexline ) ) ;
         elsif ihexutil_cli.addcrcaddress > 0
         then
            put_line("CRC generation needs mcu name and type specifications");
         end if ;
      end if ;
   end ;
   
end ihexutil ;                         -- [clitest/$]
