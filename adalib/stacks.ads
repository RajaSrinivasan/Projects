with Ada.Containers.Indefinite_Vectors;
generic
   type Item_Type (<>) is private;
   with function "=" (Left, Right : Item_Type) return Boolean is <>;
package Stacks is
   package Stk_Pkg is new Ada.Containers.Indefinite_Vectors
     (Index_Type   => Positive,
      Element_Type => Item_Type);
   function Create (Depth : Integer := 64) return Stk_Pkg.Vector;
   procedure Push (Stk : in out Stk_Pkg.Vector; Item : Item_Type);
   procedure Pop (Stk : in out Stk_Pkg.Vector; Item : out Item_Type);
   function Top (Stk : Stk_Pkg.Vector) return Item_Type;
   function Empty (Stk : Stk_Pkg.Vector) return Boolean;
end Stacks;
