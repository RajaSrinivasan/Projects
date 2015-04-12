package body Prom_Models is

   procedure Converter
     (module  : ByteProm_Pkg.module_type;
      binrec  : out Ihbr.Ihbr_Binary_Record_Type;
      context : in out context_type)
   is
      use interfaces ;
      eofrec : ihbr.ihbr_binary_record_type( ihbr.End_Of_File_Rec ) ;
      datarec : ihbr.Ihbr_Binary_Record_Type( ihbr.Data_Rec ) ;
   begin
      if context.called = 0
      then
         context.called := 1 ;
         context.nextbyte := 1 ;
      end if ;
      if context.nextbyte > module.all'length
      then
         binrec := eofrec ;
         return ;
      end if ;
      datarec.DataRecLen := 0 ;
      datarec.LoadOffset := unsigned_16( context.nextbyte -1 ) ;
      for b in 1..context.blocksize
      loop
         datarec.data(b) := module.all( context.nextbyte ) ;
         datarec.datareclen := datarec.datareclen + 1 ;
         context.nextbyte := context.nextbyte + 1 ;
         if context.nextbyte > module.all'length
         then
            exit ;
         end if ;
      end loop ;
      binrec := datarec ;
   end Converter;
end Prom_Models;
