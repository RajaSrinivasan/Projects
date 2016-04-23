with Text_IO;               use Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with linecount_cli;
with linecount_pkg;
procedure linecount is
begin
   linecount_cli.ProcessCommandLine;
   if linecount_cli.verbose then
      if linecount_cli.recursive then
         Text_IO.Put ("Recursive linecount ");
         Text_IO.Put (" File type filter ");
         Text_IO.Put (To_String (linecount_cli.filetype));
      else
         Text_IO.Put ("File linecount ");
      end if;
      Text_IO.New_Line;
   end if;

   loop
      declare
         arg : String := linecount_cli.GetNextArgument;
      begin
         if arg'Length = 0 then
            exit;
         end if;
         if linecount_cli.verbose then
            Text_IO.Put_Line (arg);
         end if;
         if linecount_cli.recursive then
            linecount_pkg.Count (arg, To_String (linecount_cli.filetype));
         else
            linecount_pkg.Count (arg);
         end if;
      end;
   end loop;
   linecount_pkg.ShowSummary;
end linecount;
