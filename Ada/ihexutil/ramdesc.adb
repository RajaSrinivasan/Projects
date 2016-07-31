with Text_Io; use Text_Io ;
with Ada.Long_Integer_Text_Io ; use Ada.Long_Integer_Text_Io ;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded ;
package body ramdesc is

    procedure show( sector : sector_type ) is
    begin
        put( to_string(sector.name) ) ;
        Set_Col( 12) ;
        put( Long_Integer( sector.start ) , width => 10 , base => 16 ) ;
        Set_Col( 25) ;
        put( Long_Integer( sector.length ) , width => 6 , base => 16 ) ;
        new_line ;
    end show ;
    procedure show( ram : ram_type ) is
    begin
       for sector in ram'range
       loop
          show( ram(sector) ) ;
       end loop ;
    end show ;
end ramdesc ;
