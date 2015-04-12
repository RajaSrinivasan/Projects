package body Prom_Models is

   procedure Converter
     (module  :        ByteProm_pkg.module_type;
      binrec  :    out Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type)
   is
      use Interfaces;
      eofrec  : Ihbr.Ihbr_Binary_Record_Type (Ihbr.End_Of_File_Rec);
      datarec : Ihbr.Ihbr_Binary_Record_Type (Ihbr.Data_Rec);
   begin
      if context.called = 0 then
         context.called   := 1;
         context.nextbyte := 1;
      end if;
      if context.nextbyte > module.all'Length then
         binrec := eofrec;
         return;
      end if;
      datarec.DataRecLen := 0;
      datarec.LoadOffset := Unsigned_16 (context.nextbyte - 1);
      for b in 1 .. context.blocksize loop
         datarec.Data (b)   := module.all (context.nextbyte);
         datarec.DataRecLen := datarec.DataRecLen + 1;
         context.nextbyte   := context.nextbyte + 1;
         if context.nextbyte > module.all'Length then
            exit;
         end if;
      end loop;
      binrec := datarec;
   end Converter;
end Prom_Models;
