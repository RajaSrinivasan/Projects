package body Stacks is
   function Create (Depth : Integer := 64) return Stk_Pkg.Vector is
      Newstack : Stk_Pkg.Vector;
   begin
      Stk_Pkg.Reserve_Capacity (Newstack, Ada.Containers.Count_Type (Depth));
      return Newstack;
   end Create;
   procedure Push (Stk : in out Stk_Pkg.Vector; Item : Item_Type) is
   begin
      Stk_Pkg.Append (Stk, Item);
   end Push;

   procedure Pop (Stk : in out Stk_Pkg.Vector; Item : out Item_Type) is
      Topitem : Item_Type := Stk_Pkg.Last_Element (Stk);
   begin
      Stk_Pkg.Delete_Last (Stk);
      Item := Topitem;
   end Pop;

   function Top (Stk : Stk_Pkg.Vector) return Item_Type is
   begin
      return Stk_Pkg.Last_Element (Stk);
   end Top;

   function Empty (Stk : Stk_Pkg.Vector) return Boolean is
   begin
      return Stk_Pkg.Is_Empty (Stk);
   end Empty;

end Stacks;
