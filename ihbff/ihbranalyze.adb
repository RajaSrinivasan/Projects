with ada.command_line ;
with ihbr ;
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
      end ;
   end loop ;
   ihbr.close(ihbrfile) ;
end ihbranalyze ;
