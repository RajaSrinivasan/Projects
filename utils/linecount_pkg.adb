With Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
package body linecount_pkg is
    summary : summary_pkg.Map ;
    procedure Count( filename : string ) is
        line : string(1..1024) ;
        linelength : natural ;
        numlines : integer := 0 ;
        file : Ada.Text_Io.File_Type ;
    begin
        Ada.Text_Io.Open( file , Ada.Text_Io.In_File , filename ) ;
        while not Ada.Text_Io.End_Of_File( file )
        loop
            Ada.Text_Io.Get_Line( file , line , linelength ) ;
            numlines := numlines + 1 ;
        end loop ;

        Summary_Pkg.Insert( summary
                            , To_Unbounded_String(Ada.Text_Io.Name(file))
                            , numlines );

        Ada.Text_Io.Close( file ) ;
    end Count ;

    procedure Print( cursor : summary_pkg.cursor ) is
    begin
        Put(To_String(Summary_Pkg.Key(cursor))) ;
        Put(" := ");
        Put(Summary_Pkg.Element(cursor)) ;
        New_Line ;
    end Print ;

    procedure ShowSummary is
    begin
       Summary_Pkg.Iterate( summary , print'access);
    end ShowSummary ;
end linecount_pkg ;
