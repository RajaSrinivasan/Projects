with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Exceptions ;
with GNAT.Source_Info ;

with cli ;                            -- [cli/$_cli]
procedure clitest is                  -- [clitest/$]
begin
   cli.ProcessCommandLine ;           -- [cli/$_cli]
   if cli.Verbose                     -- [cli/$_cli]
   then
      cli.ProcessCommandLine ;        -- [cli/$_cli]
   end if ;
exception
   when error : others =>
      Put("Exception : "); Put( Ada.Exceptions.Exception_Name( error ) ) ;
      New_Line ;
      Put( GNAT.Source_Info.Enclosing_Entity ) ;
      Put( " : " ) ;
      Put( GNAT.Source_Info.Source_Location ) ;
      New_Line ;
end clitest ;                         -- [clitest/$]
