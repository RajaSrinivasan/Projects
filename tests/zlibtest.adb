with Ada.Text_Io; use Ada.Text_Io;
with Interfaces.C ; use Interfaces.C ;
with Interfaces.C.Strings ; use Interfaces.C.Strings ;
with zlib ;
procedure zlibtest is
begin
    put("Zlib version is ");
    put_line( Value(zlib.Version) );
end zlibtest ;
