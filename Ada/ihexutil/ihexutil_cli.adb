with Ada.Text_Io; use Ada.Text_Io;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with Ada.Long_Integer_Text_Io; use Ada.Long_Integer_Text_Io;

with Ada.Strings.Fixed ; use Ada.Strings.Fixed ;

with gnat.command_line ;

package body ihexutil_cli is                          -- [cli/$_cli]
    use gnat.strings ;
    procedure SwitchHandler
      (Switch    : String;
       Parameter : String;
       Section   : String) is
    begin
       if Verbose
       then
          put ("SwitchHandler " & Switch ) ;
          put (" Parameter " & Parameter) ;
          put (" Section " & Section);
          new_line ;
       end if ;
       if Switch = "-x"
       then
          hexline := to_unbounded_string( Parameter ) ;
       end if;

      if Switch = "-c" or Switch = "--mcu-spec"
      then
         declare
            sep : integer ;
         begin
            sep := Index( Parameter , ":" ) ;
            if sep = 0
            then
               Put_Line("MCU spec should be of the form name:type") ;
               raise Program_Error ;
            end if ;
            mcuname := to_unbounded_string( head( Parameter , sep - 1 ) ) ;
            mcutype := to_unbounded_string(Parameter(sep+1 .. Parameter'last)) ;
         end ;
      end if ;
    end SwitchHandler ;

    procedure ProcessCommandLine is
        Config : GNAT.Command_Line.Command_Line_Configuration;
    begin
      GNAT.Command_Line.Define_Switch (Config,
                                       verbose'access ,
                                       Switch => "-v?",
                                       Long_Switch => "--verbose?",
                                       Help => "Output extra verbose information");
       GNAT.Command_Line.Define_Switch (Config,
                                        showoption'access ,
                                        Switch => "-s",
                                        Long_Switch => "--show",
                                        Help => "Show the contents of the hex file");

      GNAT.Command_Line.Define_Switch (Config,
                                       addcrcaddress'access ,
                                       Switch => "-a:",
                                       Long_Switch => "--add-crc:",
                                       Help => "Add computed CRC at address specified");

      GNAT.Command_Line.Define_Switch (Config,
                                       Outputname'access ,
                                       Switch => "-o:",
                                       Long_Switch => "--output:",
                                       Help => "Output file name");
      GNAT.Command_Line.Define_Switch (Config,
                                       Switch => "-x:",
                                       Long_Switch => "--hexline:",
                                       Help => "Compute checksum for the hexline");

      GNAT.Command_Line.Define_Switch( Config ,
                                       Switch => "-c:" ,
                                       Long_Switch => "--mcu-spec:" ,
                                       Help => "MCU name and type e.g. PMD:f2810 or AHP:msc1210" ) ;

      GNAT.Command_Line.Getopt(config,SwitchHandler'access);

    end ProcessCommandLine;

    function GetNextArgument return String is
    begin
        return GNAT.Command_Line.Get_Argument(Do_Expansion => True) ;
    end GetNextArgument ;


   procedure ShowArguments is
   begin
      Put_Line("-----------------------------------------------------------") ;
      Put("Show Option : ") ;
      Put_Line(boolean'image(showoption)) ;

      Put("Hex Line    : ") ;
      Put_Line(to_string(hexline )) ;
      Put("Add crc @   : ") ;
      Put(addcrcaddress) ;
      new_line ;
      Put("Output File : ");
      Put_Line(outputname.all);

      Put("MCU Name ");
      put_line(to_string(mcuname));
      Put("MCU Type ");
      Put_Line(to_string(mcutype)) ;
      Put_Line("-----------------------------------------------------------") ;
   end ShowArguments ;

end ihexutil_cli ;                                   -- [cli/$_cli]
