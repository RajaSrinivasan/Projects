with cli ;                            -- [cli/$_cli]
procedure clitest is                  -- [clitest/$]
begin
   cli.ProcessCommandLine ;           -- [cli/$_cli]
   if cli.Verbose                     -- [cli/$_cli]
   then
      cli.ProcessCommandLine ;        -- [cli/$_cli]
   end if ;
end clitest ;                         -- [clitest/$]
