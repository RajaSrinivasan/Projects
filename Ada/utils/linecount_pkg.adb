with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Directories;

with Linecount_Cli ;
package body linecount_pkg is
   summary         : summary_pkg.Map;
   filetypesummary : Stats_pkg.Map;
   
   procedure Count (filename : String) is
      line       : String (1 .. 1024);
      linelength : Natural;
      numlines   : Integer := 0;
      file       : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Open (file, Ada.Text_IO.In_File, filename);
      while not Ada.Text_IO.End_Of_File (file) loop
         Ada.Text_IO.Get_Line (file, line, linelength);
         numlines := numlines + 1;
      end loop;

      summary_pkg.Insert
        (summary,
	 To_Unbounded_String(Filename) ,
         numlines);

      declare
         fileext : String :=
           Ada.Directories.Extension (Ada.Text_IO.Name (file));
         cursor : Stats_pkg.Cursor;
         use Stats_pkg;
	 Filetypestats : Stats_Type ;
      begin
         cursor :=
           Stats_pkg.Find (filetypesummary, To_Unbounded_String (fileext));
         if cursor = Stats_pkg.No_Element then
	    Put("Creating file type ");
	    Put_Line(Fileext) ;
	    Filetypestats.Filecount := 1 ;
	    Filetypestats.Linecount := Numlines ;
            Stats_Pkg.Insert
              (filetypesummary,
               To_Unbounded_String (fileext),
               Filetypestats );
         else
	    Filetypestats := Stats_Pkg.Element(Cursor) ;
	    Filetypestats.Filecount := Filetypestats.Filecount + 1 ;
	    filetypestats.Linecount := Filetypestats.Linecount + Numlines ;
            Stats_pkg.Replace_Element
              (filetypesummary,
               cursor,
               Filetypestats );
         end if;
      end;
      Ada.Text_IO.Close (file);
   end Count;

   procedure Count (dirname : String; pattern : String) is
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
         Count (Ada.Directories.Full_Name (direntry));
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
            Count (Ada.Directories.Full_Name (direntry), pattern);
         end if;
      end loop;
      Ada.Directories.End_Search (search);
   end Count;

   procedure Print (cursor : summary_pkg.Cursor) is
   begin
      Put (To_String (summary_pkg.Key (cursor)));
      Put ( Ascii.Ht ) ;
      Put (summary_pkg.Element (cursor));
      New_Line;
   end Print;
   
   procedure Print (cursor : Stats_pkg.Cursor) is
      Filetypestats : Stats_Type ;
   begin
      Filetypestats := Stats_Pkg.Element(Cursor) ;
      Put (To_String (Stats_pkg.Key (cursor)));
      Set_Col(8);
      Put (Filetypestats.Filecount);
      Set_Col(20);
      Put (Filetypestats.LineCount) ;
      New_Line;
   end Print;

   procedure ShowSummary is
   begin
      if Linecount_Cli.Verbose
      then
	 summary_pkg.Iterate (summary, Print'Access);
      end if ;
      
      Put_Line ("File Type Summary");
      Put("Type") ;
      Set_Col(10) ;
      Put("FileCount") ;
      Set_Col(22) ;
      Put("LineCount");
      New_Line ;
      Stats_pkg.Iterate (filetypesummary, Print'Access);
   end ShowSummary;
end linecount_pkg;
