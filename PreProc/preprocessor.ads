package PreProcessor is
   Verbose : Boolean := True ;
   procedure Initialize ;

   function Defined( Symbol : String ) return Boolean ;
   function Value( Symbol : String ) return String ;
   function Equal( Symbol : String ;
                   Value : String ) return Boolean ;

   procedure Define( Symbol : String ;
                     Value : String := "" ) ;

end PreProcessor ;
