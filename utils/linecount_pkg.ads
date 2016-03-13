with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Ordered_Maps;

package linecount_pkg is
   package summary_pkg is new Ada.Containers.Indefinite_Ordered_Maps
     (Unbounded_String,
      Integer);
   procedure Count (filename : String);
   procedure Count (dirname : String; pattern : String);
   procedure ShowSummary;
end linecount_pkg;
