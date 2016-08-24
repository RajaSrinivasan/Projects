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
            Text_IO.Put_Line ("****************************************");
            Text_Io.Put("File name : ");
            Text_IO.Put_Line (arg);
            Text_Io.Put("Blocklength : ");
            Text_Io.Put(Integer'Image( dump_cli.Blocklen ) );
	    Text_Io.New_Line ;
         end if;
         Hex.dump.file.Dump (arg , blocklen => dump_cli.blocklength );
      end;
   end loop;
end dump;
