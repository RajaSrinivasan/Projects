with ada.command_line ;
with ada.text_io ; use ada.text_io ;

with ihbr ;
with hex ;

procedure ihbranalyze is
   hexfilename : string := ada.command_line.Argument(1) ;
   ihbrfile : ihbr.file_type ;

begin
   ihbr.open( hexfilename , ihbrfile ) ;
   while not ihbr.End_Of_File(ihbrfile)
   loop
      declare
         nextrec : ihbr.Ihbr_Binary_Record_Type ;
      begin
         ihbr.GetNext( ihbrfile , nextrec ) ;
         put("Load :");
         put( hex.image( nextrec.LoadOffset ));
         put(" ");
         put_line( hex.image( nextrec.Data'Address , integer(nextrec.DataRecLen) ) ) ;
      end ;
   end loop ;
   ihbr.close(ihbrfile) ;
end ihbranalyze ;
