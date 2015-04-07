with ada.command_line ;
with ada.text_io ; use ada.text_io ;

with ihbr ;
with hex ;

procedure ihbranalyze is
   hexfilename : string := ada.command_line.Argument(1) ;
   ihbrfile : ihbr.file_type ;
   ihbroutfile : ihbr.file_type ;
begin
   ihbr.open( hexfilename , ihbrfile ) ;
   ihbroutfile := ihbr.create( hexfilename & ".out" ) ;
   while not ihbr.End_Of_File(ihbrfile)
   loop
      declare
         nextrec : ihbr.Ihbr_Binary_Record_Type ;
      begin
         ihbr.GetNext( ihbrfile , nextrec ) ;
         case nextrec.Rectype is
            when ihbr.Data_Rec =>
               put("Load :");
               put( hex.image( nextrec.LoadOffset ));
               put(" ");
               put_line( hex.image( nextrec.Data'Address , integer(nextrec.DataRecLen) ) ) ;
            when ihbr.End_Of_File_Rec =>
               put_line("End Of File Rec");
            when others =>
               null ;
         end case ;
         ihbr.PutNext(ihbroutfile,nextrec) ;
      end ;
   end loop ;
   ihbr.close(ihbrfile) ;
   ihbr.close(ihbroutfile) ;
end ihbranalyze ;
