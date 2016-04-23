with Text_IO; use Text_IO;
with Hex.dump.file;

with dump_cli;
procedure dump is
begin
   dump_cli.ProcessCommandLine;
   loop
      declare
         arg : String := dump_cli.GetNextArgument;
      begin
         if arg'Length = 0 then
            exit;
         end if;
         if dump_cli.verbose then
            Text_IO.Put ("* Dumping ***************************************");
            Text_IO.Put_Line (arg);
         end if;
         Hex.dump.file.Dump (arg);
      end;
   end loop;
end dump;
