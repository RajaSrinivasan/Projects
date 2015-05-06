with ada.text_io ; use ada.text_io ;
with ada.integer_text_io ; use ada.integer_text_io ;

package body striptabs_options is

   procedure ShowUsage is
      procedure Switch (sw : String; argind : String; help : String) is
      begin
         Put (ASCII.HT);
         Put ('-');
         Put (sw);
         Put (ASCII.HT);
         Put (argind);
         Put (ASCII.HT);
         Put_Line (help);
      end Switch;
   begin
      Put_Line (Version);
      Put_Line( "usage: striptabs [-h] [-v] [-t <no] -o <name> <inputfilename>");
      Switch ("h", "", "help");
      Switch ("v", "", "verbose");
      Switch ("o", "<name>", "output file name");
      Switch ("t", "<no>" , "tab width") ;
   end ShowUsage;
   procedure ProcessCommandLine is
   begin
      loop
         case GNAT.Command_Line.Getopt ("h o: t: v") is
            when ASCII.NUL =>
               exit;
            when 'h' =>
               ShowUsage;
            when 'o' =>
                  OutputFileName :=
                 To_Unbounded_String (GNAT.Command_Line.Parameter);
            when 't' =>
               tabwidth := positive'value( gnat.Command_Line.parameter ) ;
            when others =>
               raise Program_Error;
         end case ;
      end loop ;
      InputFileName := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
   end ProcessCommandLine ;

   procedure DisplayOptions is
   begin
      Put_Line("--------------------Options----------------------");
      put("Input File Name  => "); Put_Line(to_string(inputfilename)) ;
      put("Output File Name => "); Put_Line(to_string(outputfilename)) ;
      put("Tab width        => "); put(integer(tabwidth)) ; new_line ;
      Put_Line("-------------------------------------------------");
   end DisplayOptions ;

end striptabs_options ;
