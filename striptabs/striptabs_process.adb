with ada.text_io ; use ada.text_io ;
with ada.strings.unbounded ; use ada.strings.Unbounded ;

with striptabs_options ;
package body striptabs_process is
   package options renames striptabs_options ;
   procedure Run is
      inputfile : ada.text_io.File_Type ;
      outputfile : ada.text_io.file_type ;
      linenumber : natural := 0 ;
      columnnumber : natural := 0 ;

      procedure process_line is
         nextchar : character ;
      begin
         linenumber := linenumber + 1 ;
         columnnumber := 0 ;
         while not end_of_file(inputfile)
         loop
            while not End_Of_Line(inputfile)
            loop
               ada.text_io.get( inputfile , nextchar ) ;
               columnnumber := columnnumber + 1 ;
               case nextchar is
                  when ascii.ht =>
                     ada.text_io.put( outputfile , ' ' ) ;
                     columnnumber := columnnumber + 1 ;
                     while (columnnumber mod options.tabwidth) /= 0
                     loop
                        ada.text_io.put( outputfile , ' ' ) ;
                        columnnumber := columnnumber + 1 ;
                     end loop ;
                  when others =>
                     ada.text_io.put( outputfile , nextchar ) ;
                     columnnumber := columnnumber + 1 ;
               end case ;
            end loop ;
            ada.text_io.new_line(outputfile);
            ada.text_io.skip_line(inputfile);
            exit ;
         end loop ;
      end process_line ;

   begin
      Open(inputfile,ada.text_io.In_File, to_string(options.inputfilename) ) ;
      Create(outputfile, ada.text_io.Out_File , to_string(options.outputfilename)) ;
      while not end_of_file(inputfile)
      loop
         process_line ;
      end loop ;
      close(inputfile) ;
      close(outputfile) ;
   end Run ;

end striptabs_process ;
