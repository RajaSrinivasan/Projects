with ihbr ;
generic
   type word_type is  (<>) ;
   type context_type is private ;
package prom is

   type cells_type is array (Positive range <>) of word_type ;
   type module_type is access all cells_type ;

   function create( size : Positive ) return module_type ;
   procedure erase( module : in out module_type ;
                    value : word_type := word_type'last ) ;
   procedure Set( module : in out module_type ;
                  address : positive ;
                  value : word_type ) ;
   function Get( module : module_type ;
                 address : positive ) return word_type ;
   type extractor_procedure is access
     procedure( module : in out module_type ;
                binrec : ihbr.ihbr_Binary_Record_Type ;
                context : in out context_type ) ;
   procedure Load( filename : string ;
                   module : out module_type ;
                   context : in out context_type ;
                   extractor : extractor_procedure ) ;
   type converter_procedure is access
     procedure( module : module_type ;
                binrec : out ihbr.ihbr_Binary_Record_Type ;
                context : in out context_type ) ;
   procedure Save( filename : string ;
                   module : module_type ;
                   context : in out context_type ;
                   converter : converter_procedure ) ;

end prom ;
