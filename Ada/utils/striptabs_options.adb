with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

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
        Put_Line ("usage: striptabs [-h] [-v] [-t <no] -o <name> <inputfilename>");
        Switch ("h", "", "help");
        Switch ("v", "", "verbose");
        Switch ("o", "<name>", "output file name");
        Switch ("t", "<no>", "tab width");
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
                    outputfilename := To_Unbounded_String (GNAT.Command_Line.Parameter);
                when 't' =>
                    tabwidth := Positive'VALUE (GNAT.Command_Line.Parameter);
                when others =>
                    raise Program_Error;
            end case;
        end loop;
        inputfilename := To_Unbounded_String (GNAT.Command_Line.Get_Argument);
    end ProcessCommandLine;

    procedure DisplayOptions is
    begin
        Put_Line ("--------------------Options----------------------");
        Put ("Input File Name  => ");
        Put_Line (To_String (inputfilename));
        Put ("Output File Name => ");
        Put_Line (To_String (outputfilename));
        Put ("Tab width        => ");
        Put (Integer (tabwidth));
        New_Line;
        Put_Line ("-------------------------------------------------");
    end DisplayOptions;

end striptabs_options;
