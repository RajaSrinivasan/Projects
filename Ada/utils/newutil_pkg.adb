with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.strings.unbounded ; use ada.strings.unbounded ;
with Ada.Strings.fixed ;     use Ada.strings.fixed ;
with Ada.Streams.Stream_IO;
with ada.directories ;
with GNAT.regpat ;

with gnatcoll.json ;

with newutil_cli ;
package body newutil_pkg is
    currentconfig : unbounded_string := to_unbounded_string(defaultconfig) ;
    configobj : gnatcoll.json.JSON_Value ;

    procedure show_config is
    begin
        put_line( to_string(currentconfig)) ;
    end show_config ;

    buildtemplates : boolean := false ;

    procedure Handler
                  (Name  : in GNATCOLL.json.UTF8_String;
                   Value : in GNATCOLL.json.JSON_Value) is
        use GNATCOLL.json ;

    begin
      case Kind (Val => Value) is
          when JSON_Null_Type =>
             Put_Line (Name & "(null):null");
          when JSON_Boolean_Type =>
             Put_Line (Name & "(boolean):" & Boolean'Image (Get (Value)));
          when JSON_Int_Type =>
             Put_Line (Name & "(integer):" & Integer'Image (Get (Value)));
          when JSON_Float_Type =>
             Put_Line (Name & "(float):" & Float'Image (Get (Value)));
          when JSON_String_Type =>
             if Name = "templatedir"
             then
                templatedir := gnatcoll.json.Get(Value) ;
             elsif buildtemplates
             then
                numtemplates := numtemplates + 1 ;
                templates(numtemplates) := to_unbounded_string(Name);
                template_values(numtemplates) := Get(Value) ;
                put_line("Found another template file");
             end if ;
             Put_Line (Name & "(string):" & Get (Value));
          when JSON_Array_Type =>
             if Name = "templates"
             then
                 declare
                    A_JSON_Array : constant JSON_Array := Get (Val => Value);
                    A_JSON_Value : JSON_Value;
                    Array_Length : constant Natural := Length (A_JSON_Array);
                 begin
                    Put (Name & "(array):[");
                    for J in 1 .. Array_Length loop
                       A_JSON_Value := Get (Arr   => A_JSON_Array,
                                            Index => J);

                       Put (to_string(Get(A_JSON_Value)));

                       if J < Array_Length then
                          Put (", ");
                       end if;
                    end loop;
                    Put ("]");
                    New_Line;
                 end;
             end if ;
          when JSON_Object_Type =>
             Put_Line (Name & "(object):");
             buildtemplates := true ;
             Map_JSON_Object (Val => Value,
                              CB  => Handler'Access);
             buildtemplates := false ;
    end case;
   --  Decide output depending on the kind of JSON field we're dealing with.
   --  Note that if we get a JSON_Object_Type, then we recursively call
   --  Map_JSON_Object again, which in turn calls this Handler procedure.
end Handler;

    procedure ParseConfig is
    begin
        configobj := gnatcoll.json.Read( to_string(currentconfig) ,
                                         Filename => "");
        gnatcoll.json.Map_JSON_Object (Val   => configobj ,
                                       CB    => Handler'Access);
    end ParseConfig ;

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
       ParseConfig ;
    end load_config ;

    linemarker_exp : constant string := "\[(\w+)\/\$(\w*)\]" ;
    linemarker_matcher : GNAT.Regpat.Pattern_Matcher
                                := GNAT.Regpat.Compile (linemarker_exp);

    procedure process_file(filename : string ) is
       file : ada.text_io.file_type ;
       line : string(1..1024) ;
       linelen : natural ;
       linenum : integer := 0 ;
       Matches : GNAT.Regpat.Match_Array (0 .. 2);
       use GNAT.Regpat ;
    begin
       ada.text_io.open(file,ada.text_io.in_file,filename) ;
       while not ada.text_io.end_of_file(file)
       loop
           ada.text_io.get_line(file,line,linelen) ;
           linenum := linenum + 1 ;
           gnat.regpat.match( linemarker_matcher , line(1..linelen) , matches) ;
           if Matches(0) /= GNAT.Regpat.No_Match
           then
              put(linenum) ;
              put (" : ") ;
              put_line(line(1..linelen));
              put( "Will Subsitute ") ;
              put( line (Matches (1).First .. Matches (1).Last) ) ;
              put( " by PROGNAME") ;
              put( line (Matches (2).First .. Matches (2).Last) ) ;
              new_line ;
           end if ;
       end loop ;
       ada.text_io.close(file);
    end process_file ;

    procedure process_file( filename : string ;
                            outputfilename : string ;
                            progname : string ) is
        file, ofile : ada.text_io.file_type ;
        line : string(1..1024) ;
        linelen : natural ;
        linenum : integer := 0 ;
        Matches : GNAT.Regpat.Match_Array (0 .. 2);

        startsearch : integer ;
        startsubst : integer ;
        use GNAT.Regpat ;
    begin
        if Ada.Directories.Exists( outputfilename )
        then
           Put(outputfilename) ;
           Put(" already exists.") ;
           if newutil_cli.overwrite
           then
               put_line(" Will overwrite.") ;
           else
               put_line(" Will not overwrite. Use -O to overwrite.");
               return ;
           end if ;
        end if ;
        ada.text_io.open(file,ada.text_io.in_file,filename) ;
        ada.text_io.create(ofile , ada.text_io.out_file , outputfilename );
        while not ada.text_io.end_of_file(file)
        loop
            ada.text_io.get_line(file,line,linelen) ;
            linenum := linenum + 1 ;

            gnat.regpat.match( linemarker_matcher , line(1..linelen) , matches) ;
            if Matches(0) = GNAT.Regpat.No_Match
            then
               Ada.Text_Io.Put_Line(ofile,line(1..linelen));
            else
               put(linenum) ;
               put (" : ") ;
               put_line(line(1..linelen));
               put( "Will Subsitute ") ;
               put( line (Matches (1).First .. Matches (1).Last) ) ;
               put( " by PROGNAME") ;
               put( line (Matches (2).First .. Matches (2).Last) ) ;
               new_line ;
               startsearch := 1 ;
               while startsearch < matches(1).first
               loop
                   startsubst := Ada.Strings.Fixed.Index( line(startsearch..matches(1).first-1) ,
                                                    line(Matches (1).First .. Matches (1).Last) ,
                                                    startsearch ) ;
                   if startsubst < startsearch
                   then
                       Ada.Text_Io.put_line(ofile,line(startsearch..linelen));
                       exit ;
                   end if ;
                   Ada.Text_Io.Put(ofile,line(startsearch..startsubst-1)) ;
                   Ada.Text_Io.Put(ofile,progname);
                   Ada.Text_Io.Put(ofile,line (Matches (2).First .. Matches (2).Last) ) ;
                   startsearch := startsubst + Matches(1).Last - Matches(1).First + 1 ;
               end loop ;
            end if ;
        end loop ;
        ada.text_io.close(file);
        ada.text_io.close(ofile);
    end process_file ;
end newutil_pkg ;
