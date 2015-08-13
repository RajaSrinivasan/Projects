with ada.command_line ;
with ada.text_io; use ada.text_io;
with gnat.Command_Line ;

with PreProcessor ;

procedure preproc is
   procedure show_usage is
   begin
      put_line("preproc inp out");
   end show_usage ;
begin
   if ada.command_line.argument_count < 2
   then
      show_usage ;
      return ;
   end if ;
   PreProcessor.Process( ada.Command_Line.argument(1) , ada.command_line.argument(2) ) ;
end preproc ;
