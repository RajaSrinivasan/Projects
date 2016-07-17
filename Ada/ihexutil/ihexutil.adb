with Ada.Text_Io; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;

with ihbr ; use ihbr ;

with ihexutil_cli ;                            -- [cli/$_cli]

procedure ihexutil is                  -- [clitest/$]
begin
   ihexutil_cli.ProcessCommandLine ;           -- [cli/$_cli]
   declare
      arg : String := ihexutil_cli.GetNextArgument;
   begin
      if ihexutil_cli.Verbose
      then
         Put_Line("-----------------------------------------------------------") ;
         Put("Show Option : ") ;
         Put_Line(boolean'image(ihexutil_cli.showoption)) ;
         Put("Hex File    : ") ;
         Put_Line(arg) ;
         Put_Line("-----------------------------------------------------------") ;
      end if ;
      if ihexutil_cli.showoption
      then
         declare
            hexfile : ihbr.File_Type ;
            hexrec : ihbr.Ihbr_Binary_Record_Type ;
            linecount : Integer := 0 ;
         begin
            ihbr.Open( arg , hexfile );
            while not ihbr.End_Of_File( hexfile )
            loop
                ihbr.GetNext( hexfile , hexrec ) ;
                linecount := linecount + 1 ;
                case hexrec.Rectype is
                   when Extended_Lin_Adr_Rec =>
                      Put("ExtLinA ");
                      Set_Col(12) ;
                      Put(long_integer'image(long_integer(hexrec.Linear_Base_Address))) ;
                      New_Line ;
                   when Extended_Seg_Adr_Rec =>
                      Put("ExtSegA ");
                      Set_Col(12) ;
                      Put(long_integer'image(long_integer(hexrec.Segment_Base_Address))) ;
                      New_Line ;
                   when Data_Rec =>
                      Put("DataRec");
                      Set_Col(12) ;
                      Put("Load Offset ") ;
                      Put( Integer(hexrec.LoadOffset) );
                      put(" length ") ;
                      Put( Integer(hexrec.DataRecLen) );
                      New_Line ;
                   when Start_Lin_Adr_Rec =>
                      Put("LinStA ");
                      Set_Col(12) ;
                      Put(long_integer'image(long_integer(hexrec.Exec_LinStart_Adr))) ;
                      New_Line ;
                   when Start_Seg_Adr_Rec =>

                      Put("SegStA ");
                      Set_Col(12) ;
                      Put(long_integer'image(long_integer(hexrec.Exec_SegStart_Adr))) ;
                      New_Line ;
                   when End_Of_File_Rec =>
                        Put_Line("End_Of_File_Rec") ;
                        New_Line ;
                   when Unknown_Rec =>
                      null ;
                end case;
            end loop ;
            ihbr.Close( hexfile ) ;
            Put(Integer'Image(linecount));
            Put(" lines read from ");
            Put_Line(arg);
         end ;
      end if ;
   end ;
end ihexutil ;                         -- [clitest/$]
