with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Ordered_Maps;

package linecount_pkg is
   type Stats_Type is
      record
	 Filecount : Integer := 0 ;
	 Linecount : Integer := 0 ;
      end record ;
   
   package summary_pkg is new Ada.Containers.Indefinite_Ordered_Maps
     (Unbounded_String,
      Integer );
   package Stats_Pkg is new Ada.Containers.Indefinite_Ordered_Maps
     (Unbounded_String ,
      Stats_Type) ;
   procedure Count (filename : String);
   procedure Count (dirname : String; pattern : String);
   procedure ShowSummary;
end linecount_pkg;
