with Text_Io ; use Text_Io ;
package body SymbolTable is

   procedure Print( Symbol : Stb_Pkg.Cursor ) is
   begin
      Put(To_String(Stb_Pkg.Key(Symbol))) ;
      Put(" := ");
      Put(To_String(Stb_Pkg.Element(Symbol))) ;
      New_Line ;
   end Print ;

   procedure Print( Symboltable : Stb_Pkg.Map ) is
   begin
      Stb_Pkg.Iterate( Symboltable , Print'Access ) ;
   end Print ;
end SymbolTable ;
