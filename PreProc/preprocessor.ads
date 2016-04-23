package PreProcessor is

   Verbose : Boolean := True ;

   procedure Initialize ;

   procedure process( inputfilename : string ;
                      outputfilename : string ) ;

   function Defined( Symbol : String ) return Boolean ;
   function Value( Symbol : String ) return String ;
   function Equal( Symbol : String ;
                   Val : String ) return Boolean ;

   procedure Define( Symbol : String ;
                     Val : String := "" ) ;

end PreProcessor ;
