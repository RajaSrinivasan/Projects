with Text_Io; use Text_Io;
with ada.strings.unbounded; use ada.strings.unbounded;
with linecount_cli ;
procedure linecount is
begin
   linecount_cli.ProcessCommandLine ;
   if linecount_cli.Verbose
   then
      if linecount_cli.recursive
      then
         Text_Io.Put("Recursive linecount ");
         Text_Io.Put(" File type filter ") ;
         Text_Io.Put( to_string(linecount_cli.filetype) ) ;
      else
         Text_Io.Put("File linecount ") ;
      end if ;
      Text_Io.New_Line ;
  end if ;

   loop
      declare
          arg : string := linecount_cli.GetNextArgument ;
      begin
         if arg'length = 0
         then
            exit ;
         end if;
         if linecount_cli.Verbose
         then
            Text_Io.put_line(arg) ;
        end if ;
      end ;
   end loop ;
end linecount ;
