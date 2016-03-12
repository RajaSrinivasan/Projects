With Ada.Text_Io ; use Ada.Text_Io ;
with Ada.Integer_Text_Io; use Ada.Integer_Text_Io;
with Ada.Directories ;

package body linecount_pkg is
    summary : summary_pkg.Map ;
    filetypesummary : summary_pkg.Map ;
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

        declare
            fileext : string := Ada.Directories.Extension(Ada.Text_Io.Name(file)) ;
            cursor : summary_pkg.cursor ;
            use summary_pkg ;
        begin
            cursor := summary_pkg.find(filetypesummary,to_unbounded_string(fileext));
            if cursor = summary_pkg.no_element
            then
               summary_pkg.insert(filetypesummary
                                 ,to_unbounded_string(fileext)
                                 ,1);
            else
               summary_pkg.replace_element( filetypesummary
                                          , cursor
                                          , 1 + summary_pkg.element(cursor) ) ;
            end if ;
        end ;

        Ada.Text_Io.Close( file ) ;
    end Count ;

    procedure Count( dirname : string ;
                     pattern : string ) is
        search : Ada.Directories.search_type;
        searchd : Ada.Directories.search_type ;
        direntry : Ada.Directories.Directory_Entry_Type ;
        filter : Ada.Directories.filter_type ;
        use Ada.Directories ;
    begin
        filter := ( Ada.Directories.Ordinary_File => true , others => false);

        Ada.Directories.Start_Search( search , dirname , pattern , filter) ;
        while Ada.Directories.More_Entries(search)
        loop
           Ada.Directories.Get_Next_Entry( search , direntry ) ;
           Count(Ada.Directories.Full_Name(direntry)) ;
        end loop ;
        Ada.Directories.End_Search(search) ;

        filter := ( Ada.Directories.Directory => true , others => false ) ;
        Ada.Directories.Start_Search( searchd , Ada.Directories.Full_Name(dirname) , "*" , filter) ;
        while Ada.Directories.More_Entries(searchd)
        loop
           Ada.Directories.Get_Next_Entry( searchd , direntry ) ;
           --put_line("Sub Dir " & Ada.Directories.Full_Name(direntry));
           --put_line(Integer'Image(Ada.Directories.Full_Name(direntry)'length));
           if Ada.Directories.Simple_Name(direntry) /= "." and then
              Ada.Directories.Simple_Name(direntry) /= ".."
           then
              Count( Ada.Directories.Full_Name(direntry) , pattern ) ;
           end if;
        end loop ;
        Ada.Directories.End_Search(search) ;

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
       Summary_Pkg.Iterate( summary , print'access );
       Put_Line("File Type Summary") ;
       Summary_Pkg.Iterate( filetypesummary , print'access );
    end ShowSummary ;
end linecount_pkg ;
