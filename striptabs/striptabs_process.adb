with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with striptabs_options;
package body striptabs_process is
    package options renames striptabs_options;
    procedure Run is
        inputfile    : Ada.Text_IO.File_Type;
        outputfile   : Ada.Text_IO.File_Type;
        linenumber   : Natural := 0;
        columnnumber : Natural := 0;

        procedure process_line is
            nextchar : Character;
        begin
            linenumber   := linenumber + 1;
            columnnumber := 0;
            while not End_Of_File (inputfile) loop
                while not End_Of_Line (inputfile) loop
                    Ada.Text_IO.Get (inputfile, nextchar);
                    columnnumber := columnnumber + 1;
                    case nextchar is
                        when ASCII.HT =>
                            Ada.Text_IO.Put (outputfile, ' ');
                            columnnumber := columnnumber + 1;
                            while (columnnumber mod options.tabwidth) /= 0 loop
                                Ada.Text_IO.Put (outputfile, ' ');
                                columnnumber := columnnumber + 1;
                            end loop;
                        when others =>
                            Ada.Text_IO.Put (outputfile, nextchar);
                            columnnumber := columnnumber + 1;
                    end case;
                end loop;
                Ada.Text_IO.New_Line (outputfile);
                Ada.Text_IO.Skip_Line (inputfile);
                exit;
            end loop;
        end process_line;

    begin
        Open (inputfile, Ada.Text_IO.In_File, To_String (options.inputfilename));
        Create (outputfile, Ada.Text_IO.Out_File, To_String (options.outputfilename));
        while not End_Of_File (inputfile) loop
            process_line;
        end loop;
        Close (inputfile);
        Close (outputfile);
    end Run;

end striptabs_process;
