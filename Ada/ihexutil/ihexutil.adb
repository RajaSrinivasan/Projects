with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Long_Integer_Text_Io; use Ada.Long_Integer_Text_Io;

with hex ; use hex ;
with ihbr ; use ihbr ;

with ihexutil_cli ;                            -- [cli/$_cli]
with ihexutil_pkg ;

procedure ihexutil is                  -- [clitest/$]
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
         Put("Hex File    : ") ;
         Put_Line(arg) ;
         Put("Hex Line    : ") ;
         Put_Line(to_string( ihexutil_cli.hexline )) ;
         Put_Line("-----------------------------------------------------------") ;
      end if ;
      if ihexutil_cli.showoption
      then
         ihexutil_Pkg.Show( arg ) ;
      elsif ihexutil_cli.hexline /= null_unbounded_string
      then
         ihexutil_Pkg.Checksum( to_string( ihexutil_cli.hexline ) ) ;
      end if ;
   end ;
end ihexutil ;                         -- [clitest/$]
