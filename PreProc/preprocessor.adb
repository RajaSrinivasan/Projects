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
      SymbolTable.Stb_Pkg.Insert( stb , To_Unbounded_String("__VERSION__") ,
                                To_Unbounded_String("1.0") ) ;
      SymbolTable.Stb_Pkg.Insert( stb , To_Unbounded_String("__DATE__") ,
                                To_Unbounded_String(Timestamp(1..Posspc-1)) );
      SymbolTable.Stb_Pkg.Insert( stb , To_Unbounded_String("__TIME__") ,
                                                                    To_Unbounded_String(Timestamp(Posspc+1..Posspc+8)) );
      if Verbose
      then
         SymbolTable.Print(Stb) ;
      end if ;
   end Initialize ;
end Preprocessor ;
