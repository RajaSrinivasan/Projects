with ada.Text_Io ; use ada.Text_Io ;
with Gnat.Time_Stamp ;
with Ada.Strings.Fixed ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;

with gnat.spitbol.patterns ;
with gnat.regpat ;

with SymbolTable ;
with sources ;

package body Preprocessor is
   stb : SymbolTable.Stb_Pkg.Map ;

   cmdline : string := "^\s*#" ;
   cmds : string := "\s*(if|ifdef|endif|include|define|else)(\s+|\s*$)" ;

   pcmdline : gnat.regpat.Pattern_Matcher := gnat.regpat.compile(cmdline) ;
   pcmds : gnat.regpat.pattern_matcher := gnat.regpat.compile(cmds) ;

   procedure Initialize is
      Timestamp : String := Gnat.Time_Stamp.Current_Time ;
      Posspc : Natural ;
   begin
      Posspc := Ada.Strings.Fixed.Index(Timestamp," ");
      Define("__VERSION__","1.0");
      Define("__DATE__" , Timestamp(1..Posspc-1)) ;
      Define("__TIME__" , Timestamp(Posspc+1..Posspc+8) );
      if Verbose
      then
         SymbolTable.Print(Stb) ;
      end if ;
   end Initialize ;


   procedure process( inputfilename : string ;
                      outputfilename : string ) is
      srcfile : sources.file_type ;
      outfile : ada.text_io.file_type ;
      inspecting : boolean := true ;

      procedure InspectLine( str : string ) is
         cmdindicator : gnat.regpat.match_array(0..0)  ;
         keyword : gnat.regpat.match_array(0..1) ;
      begin
         gnat.regpat.match( pcmdline , str , cmdindicator ) ;
         if cmdindicator(0).first = 0
         then
            ada.text_io.put_line(outfile,str) ;
         else
            if verbose
            then
               put("cmd :");
               put_line(str) ;
               put("indicator :");
               put_line( str(cmdindicator(0).first .. cmdindicator(0).last ) ) ;
            end if ;
            gnat.regpat.match( pcmds , str( cmdindicator(0).last + 1 .. str'last ) , keyword ) ;
            -- if keyword(0).First < cmdindicator(0).last + 1
            if keyword(0).First = 0
            then
               put_line("unrecognized keyword");
            else
               put("keyword :"); put_line( str( keyword(1).first .. keyword(1).last ) ) ;
            end if ;
         end if ;
      end InspectLine ;

      procedure process( src : in out sources.file_type ) is
         line : string(1..256) ;
         linelen : natural ;
      begin
         while not Ada.Text_Io.End_Of_File( src.file.all )
         loop
            ada.text_io.get_line( src.file.all , line , linelen );
            src.lineNo := src.lineNo + 1 ;
            if inspecting
            then
               InspectLine(line(1..linelen)) ;
            end if ;
         end loop ;
      end process ;
   begin
      srcfile := sources.open(inputfilename) ;
      ada.text_io.create( outfile , out_file , outputfilename ) ;
      Process( srcfile ) ;
      ada.text_io.close(outfile) ;
      ada.text_io.close(srcfile.file.all) ;
   end process ;

   function Defined( Symbol : String ) return Boolean is
   begin
      return SymbolTable.stb_pkg.Contains(stb,to_unbounded_string(Symbol)) ;
   end Defined ;

   function Value( Symbol : String ) return String is
   begin
      return to_string(SymbolTable.stb_pkg.Element(stb,to_unbounded_string(Symbol))) ;
   end Value ;

   function Equal( Symbol : String ;
                   Val : String ) return Boolean is
      defvalue : string := Value( Symbol ) ;
   begin
      return defvalue = Val ;
   end Equal ;

   procedure Define( Symbol : String ;
                     Val : String := "" ) is
   begin
      SymbolTable.Stb_Pkg.Insert( stb
                                    , To_Unbounded_String(Symbol)
                                    , To_Unbounded_String(Val) );
   end Define ;


end Preprocessor ;
