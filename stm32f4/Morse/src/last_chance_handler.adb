
package body Last_Chance_Handler is

   -------------------------
   -- Last_Chance_Handler --
   -------------------------

   procedure Last_Chance_Handler (Msg : System.Address; Line : Integer) is
      pragma Unreferenced (Msg, Line);
   begin
      --  No return procedure.
      pragma Warnings (Off, "*rewritten as loop");
      <<spin>> goto spin;   -- yes, a goto!
      pragma Warnings (On, "*rewritten as loop");
   end Last_Chance_Handler;

end Last_Chance_Handler;
