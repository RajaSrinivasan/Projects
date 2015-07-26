with Text_Io ; use Text_Io ;
with Gnat.Time_Stamp ;
with Ada.Strings.Fixed ;
with Ada.Strings.Unbounded ; use Ada.Strings.Unbounded ;
with SymbolTable ;

package body Preprocessor is
   Stb : SymbolTable.Stb_Pkg.Map ;
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
   function Defined( Symbol : String ) return Boolean is
   begin
      return False ;
   end Defined ;

   function Value( Symbol : String ) return String is
   begin
      return "" ;
   end Value ;

   function Equal( Symbol : String ;
                   Value : String ) return Boolean is
   begin
      return False ;
   end Equal ;

   procedure Define( Symbol : String ;
                     Value : String := "" ) is
   begin
      SymbolTable.Stb_Pkg.Insert( stb
                                    , To_Unbounded_String(Symbol)
                                    , To_Unbounded_String(Value) );
   end Define ;


end Preprocessor ;
