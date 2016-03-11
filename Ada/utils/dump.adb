with Text_Io; use Text_Io ;
with hex.dump.file ;

with dump_cli ;
procedure dump is
begin
   dump_cli.ProcessCommandLine ;
   loop
      declare
          arg : string := dump_cli.GetNextArgument ;
      begin
         if arg'length = 0
         then
            exit ;
         end if;
         if dump_cli.Verbose
         then
            Text_Io.Put("* Dumping ***************************************");
            Text_Io.Put_Line(arg);
         end if ;
         hex.dump.file.dump( arg );
      end ;
   end loop ;
end dump ;
