with Ada.Text_Io; use Ada.Text_Io;
with GNAT.strings ;
with newutil_cli ;
with newutil_pkg ;
procedure newutil is
   use type GNAT.strings.string_access ;
begin
   newutil_cli.ProcessCommandLine ;
   if newutil_cli.Verbose
   then
      put_line("Default Configuration") ;
      newutil_pkg.show_config ;
   end if ;
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
end newutil ;
