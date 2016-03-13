with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with GNAT.Strings;
with newutil_cli;
with newutil_pkg;
procedure newutil is
   use type GNAT.Strings.String_Access;
   utilname : Unbounded_String := Null_Unbounded_String;
begin
   newutil_cli.ProcessCommandLine;
   if newutil_cli.verbose then
      Put_Line ("Default Configuration");
      newutil_pkg.show_config;
   end if;
   utilname := To_Unbounded_String (newutil_cli.GetNextArgument);
   if newutil_cli.configfilename /= null
     and then newutil_cli.configfilename.all'Length /= 0
   then
      newutil_pkg.load_config (newutil_cli.configfilename.all);
      if newutil_cli.verbose then
         Put_Line ("Overridden Configuration");
         newutil_pkg.show_config;
      end if;
   end if;
   newutil_pkg.ParseConfig;
   for t in 1 .. newutil_pkg.numtemplates loop
      if Index (newutil_pkg.template_values (t), "/$NEWPROJ/") = 1 then
         declare
            finalname : String := To_String (newutil_pkg.template_values (t));
         begin
            if newutil_cli.verbose then
               Put ("Will copy ");
               Put (To_String (newutil_pkg.templates (t)));
               Put (" to ");
               Put (To_String (utilname));
               Put (finalname (11 .. finalname'Last));
               New_Line;
            end if;
            newutil_pkg.process_file
              (To_String (newutil_pkg.templatedir) &
               To_String (newutil_pkg.templates (t)),
               To_String (utilname) & finalname (11 .. finalname'Last),
               To_String (utilname));
         end;
      else
         Put_Line ("Output file Name - incorrect format");
      end if;
   end loop;
end newutil;
