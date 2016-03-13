with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.unbounded; use Ada.Strings.unbounded ;
with GNAT.strings ;
with newutil_cli ;
with newutil_pkg ;
procedure newutil is
   use type GNAT.strings.string_access ;
   utilname : unbounded_string := null_unbounded_string ;
begin
   newutil_cli.ProcessCommandLine ;
   if newutil_cli.Verbose
   then
      put_line("Default Configuration") ;
      newutil_pkg.show_config ;
   end if ;
   utilname := to_unbounded_string( newutil_cli.GetNextArgument );
   if newutil_cli.configfilename /= null and then
      newutil_cli.configfilename.all'length /= 0
   then
       newutil_pkg.load_config( newutil_cli.configfilename.all );
       if newutil_cli.Verbose
       then
          put_line("Overridden Configuration") ;
          newutil_pkg.show_config ;
       end if ;
   end if ;
   newutil_pkg.ParseConfig ;
   for t in 1..newutil_pkg.numtemplates
   loop
      if Index( newutil_pkg.template_values(t) , "/$NEWPROJ/") = 1
      then
        declare
            finalname : string := to_string(newutil_pkg.template_values(t)) ;
        begin
            if newutil_cli.Verbose
            then
                 put("Will copy ") ;
                 put( to_string(newutil_pkg.templates(t)) ) ;
                 put(" to ") ;
                 put( to_string(utilname) ) ;
                 put( finalname(11..finalname'last));
                 new_line ;
             end if ;
             newutil_pkg.process_file(
               to_string(newutil_pkg.templatedir) & to_string(newutil_pkg.templates(t))
             , to_string(utilname) & finalname(11..finalname'last)
             , to_string(utilname)) ;
          end ;
      else
          put_line("Output file Name - incorrect format");
      end if ;
   end loop ;
end newutil ;
