with Interfaces;            use Interfaces;
with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with striptabs_options ;
with striptabs_process ;

procedure striptabs is
   package options renames striptabs_options ;
   package Process renames striptabs_process ;

begin
   options.ProcessCommandLine ;
   if options.Verbose
   then
      options.DisplayOptions ;
   end if ;
   if Length(options.inputfilename) = 0
   then
      return ;
   end if ;
   if length(options.outputfilename) = 0
   then
      put_line("Please provide an output filename") ;
      return ;
   end if ;
   process.Run ;
end striptabs ;
