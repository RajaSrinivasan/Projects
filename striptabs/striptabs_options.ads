with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

with GNAT.Command_Line;

package striptabs_options is

    Version : String := "striptabs Version 0.0";

    Verbose        : Boolean          := False;
    inputfilename  : Unbounded_String := Null_Unbounded_String;
    outputfilename : Unbounded_String := Null_Unbounded_String;

    subtype TABWIDTH_RANGE_TYPE is Positive range 1 .. 8;
    tabwidth : TABWIDTH_RANGE_TYPE := 4;

    procedure ShowUsage;
    procedure ProcessCommandLine;
    procedure DisplayOptions;

end striptabs_options;
