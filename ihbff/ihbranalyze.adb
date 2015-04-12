with Ada.Command_Line;
with Ada.Text_IO; use Ada.Text_IO;

with Ihbr;
with Hex;

procedure ihbranalyze is
   hexfilename : String := Ada.Command_Line.Argument (1);
   ihbrfile    : Ihbr.File_Type;
   ihbroutfile : Ihbr.File_Type;
begin
   Ihbr.Open (hexfilename, ihbrfile);
   ihbroutfile := Ihbr.Create (hexfilename & ".out");
   while not Ihbr.End_Of_File (ihbrfile) loop
      declare
         nextrec : Ihbr.Ihbr_Binary_Record_Type;
      begin
         Ihbr.GetNext (ihbrfile, nextrec);
         case nextrec.Rectype is
            when Ihbr.Data_Rec =>
               Put ("Load :");
               Put (Hex.Image (nextrec.LoadOffset));
               Put (" ");
               Put_Line
                 (Hex.Image
                    (nextrec.Data'Address,
                     Integer (nextrec.DataRecLen)));
            when Ihbr.End_Of_File_Rec =>
               Put_Line ("End Of File Rec");
            when others =>
               null;
         end case;
         Ihbr.PutNext (ihbroutfile, nextrec);
      end;
   end loop;
   Ihbr.Close (ihbrfile);
   Ihbr.Close (ihbroutfile);
end ihbranalyze;
