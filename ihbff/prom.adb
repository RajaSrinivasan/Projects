package body prom is
   function create( size : Positive ) return module_type is
   begin
      return new cells_type( 1..size ) ;
   end create ;

   procedure erase( module : in out module_type ;
                    value : word_type := word_type'last ) is
   begin
      module.all := (others => value) ;
   end erase ;

   procedure Set( module : in out module_type ;
                  address : positive ;
                  value : word_type ) is
   begin
      module(address+1) := value ;
   end Set ;


   function Get( module : module_type ;
                 address : positive ) return word_type is
   begin
      return module(address+1) ;
   end get ;

   procedure Load( filename : string ;
                   module : out module_type ;
                   context : in out context_type ;
                   extractor : extractor_procedure ) is
      ihbrfile : ihbr.file_type ;
   begin
      ihbr.open( filename , ihbrfile ) ;
      while not ihbr.End_Of_File(ihbrfile)
      loop
         declare
            nextrec : ihbr.Ihbr_Binary_Record_Type ;
         begin
            ihbr.GetNext( ihbrfile , nextrec ) ;
            case nextrec.Rectype is
            when ihbr.Data_Rec =>
                 extractor( module , nextrec , context ) ;
            when ihbr.End_Of_File_Rec =>
               exit ;
            when others =>
               null ;
            end case ;
         end ;
      end loop ;
      ihbr.close(ihbrfile) ;
   end load ;

   procedure Save( filename : string ;
                   module : module_type ;
                   context : in out context_type ;
                   converter : converter_procedure ) is
      use ihbr ;
      ihbroutfile : ihbr.file_type ;
   begin
      ihbroutfile := ihbr.create( filename ) ;
      loop
         declare
            nextrec : ihbr.Ihbr_Binary_Record_Type ;
         begin
            converter( module ,  nextrec , context ) ;
            ihbr.PutNext( ihbroutfile , nextrec ) ;
            if nextrec.Rectype = ihbr.End_Of_File_Rec
            then
               exit ;
            end if ;
         end ;
      end loop ;
      ihbr.close(ihbroutfile) ;
   end save ;

end prom ;
