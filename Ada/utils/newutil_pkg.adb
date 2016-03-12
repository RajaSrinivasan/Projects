with ada.text_io; use ada.text_io;
with ada.strings.unbounded ; use ada.strings.unbounded ;
with Ada.Streams.Stream_IO;
with ada.directories ;
package body newutil_pkg is
    currentconfig : unbounded_string := to_unbounded_string(defaultconfig) ;
    procedure show_config is
    begin
        put_line( to_string(currentconfig)) ;
    end show_config ;

    procedure load_config( filename : string ) is

       filesize : natural := natural(ada.directories.size(filename)) ;
       use Ada.Streams ;
       file :  Ada.Streams.Stream_IO.File_Type;
       stream : Ada.Streams.Stream_IO.Stream_Access;
       buffer : Ada.Streams.Stream_Element_Array(1..Ada.Streams.Stream_Element_Offset(filesize)) ;
       bufferlen : Ada.Streams.Stream_Element_Offset ;
       filecontents : string( 1..filesize) ;
           for filecontents'Address use buffer'Address ;
    begin
       Ada.Streams.Stream_IO.Open(file,
                                  Ada.Streams.Stream_IO.In_File,
                                  filename );
       stream := Ada.Streams.Stream_Io.Stream(file);
       Stream.Read( buffer , bufferlen );
       Ada.Streams.Stream_Io.Close(file) ;
       pragma Assert( natural(bufferlen) = filesize , "entire file was not read") ;
       currentconfig := to_unbounded_string(filecontents) ;
    end load_config ;
end newutil_pkg ;
