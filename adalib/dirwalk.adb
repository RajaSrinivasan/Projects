with Ada.Directories ;

procedure dirwalk( context : context_type ;
                   dirname : string ;
                   pattern : string ;
                   processor : access procedure ( context : context_type ;
                                                  filename : in string )
                   ) is

   search   : Ada.Directories.Search_Type;
   searchd  : Ada.Directories.Search_Type;
   direntry : Ada.Directories.Directory_Entry_Type;
   filter   : Ada.Directories.Filter_Type;
   use Ada.Directories;

begin

    filter := (Ada.Directories.Ordinary_File => True, others => False);

    Ada.Directories.Start_Search (search, dirname, pattern, filter);
    while Ada.Directories.More_Entries (search) loop
       Ada.Directories.Get_Next_Entry (search, direntry);
       processor (context , Ada.Directories.Full_Name (direntry));
    end loop;
    Ada.Directories.End_Search (search);

    filter := (Ada.Directories.Directory => True, others => False);
    Ada.Directories.Start_Search
      (searchd,
       Ada.Directories.Full_Name (dirname),
       "*",
       filter);
    while Ada.Directories.More_Entries (searchd) loop
       Ada.Directories.Get_Next_Entry (searchd, direntry);
       if Ada.Directories.Simple_Name (direntry) /= "."
         and then Ada.Directories.Simple_Name (direntry) /= ".."
       then
          dirwalk (context , Ada.Directories.Full_Name (direntry), pattern, processor);
       end if;
    end loop;
    Ada.Directories.End_Search (search);

end dirwalk ;
