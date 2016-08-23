with Ada.Text_Io; use Ada.Text_Io ;
package body Queue is
   function Create( Key : String ) return Message_Type is
      Msg : Message_Type ;
   begin
      Msg.Contents := GNATCOLL.JSON.Create( Val => Key ) ;
      return Msg ;
   end Create ;
   procedure Show( Message : Message_TYpe ) is
   begin
      Put_Line( GNATCOLL.JSON.Write( Message.Contents ) ) ;
   end Show ;
   
end Queue ;
