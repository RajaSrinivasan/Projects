with Gnatcoll.Json ;
package Queue is
    Version : constant String := "V01.00.00" ;
    DefaultPort : Integer := 100756 ;
    
    type Message_Type is private ;
    function Create ( Key : String ) return Message_Type ;
    procedure Show( Message : Message_Type ) ;
private
   type Message_Type is
      record
	 Contents : GNATCOLL.JSON.JSON_Value ;
      end record ;
end Queue ;
