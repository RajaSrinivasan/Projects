with ada.text_io; use ada.text_io;
with ada.strings.Unbounded ; use ada.strings.Unbounded ;
with logging.client ;
with logging.server ;


procedure asyslogs is
begin
   logging.server.SelfTEst ;
end asyslogs ;
