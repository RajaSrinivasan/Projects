with Ada.Streams; use Ada.Streams;
with Ada.Streams.Stream_IO;
with interfaces ;

package body Prom is
   use Ada.Streams;
   function Create (size : Positive) return module_type is
   begin
      return new cells_type (1 .. size);
   end Create;

   procedure Erase
     (module : in out module_type;
      value  :        word_type := word_type'Last)
   is
   begin
      module.all := (others => value);
   end Erase;

   procedure Set
     (module  : in out module_type;
      address :        Natural;
      value   :        word_type)
   is
   begin
      module (address + 1) := value;
   end Set;

   function Get (module : module_type; address : Natural) return word_type is
   begin
      return module (address + 1);
   end Get;

   procedure Load
     (filename  :        String;
      module    :    out module_type;
      context   : in out context_type;
      extractor :        extractor_procedure)
   is
      ihbrfile : Ihbr.File_Type;
   begin
      Ihbr.Open (filename, ihbrfile);
      while not Ihbr.End_Of_File (ihbrfile) loop
         declare
            nextrec : Ihbr.Ihbr_Binary_Record_Type;
         begin
            Ihbr.GetNext (ihbrfile, nextrec);
            case nextrec.Rectype is
               when Ihbr.Data_Rec =>
                  extractor (module, nextrec, context);
               when Ihbr.End_Of_File_Rec =>
                  exit;
               when others =>
                  null;
            end case;
         end;
      end loop;
      Ihbr.Close (ihbrfile);
   end Load;

   procedure Read (filename : String; module : out module_type) is
      binfile : Stream_IO.File_Type;
   begin
      Stream_IO.Open
        (File => binfile,
         Mode => Stream_IO.In_File,
         Name => filename);
      module := new cells_type (1 .. Integer (Stream_IO.Size (binfile)));
      declare
         bindata : Ada.Streams
           .Stream_Element_Array
         (1 .. Ada.Streams.Stream_Element_Offset (Stream_IO.Size (binfile)));
         for bindata'Address use module.all'Address;
         actualsize : Ada.Streams.Stream_Element_Offset;
      begin
         Stream_IO.Read (File => binfile, Item => bindata, Last => actualsize);
      end;
      Stream_IO.Close (binfile);
   end Read;

   procedure Save
     (filename  :        String;
      module    :        module_type;
      context   : in out context_type;
      converter :        converter_procedure)
   is
      use interfaces ;
      use Ihbr;
      ihbroutfile : Ihbr.File_Type;
   begin
      ihbroutfile := Ihbr.Create (filename);
      loop
         declare
            nextrec : Ihbr.Ihbr_Binary_Record_Type;
         begin
            converter (module, nextrec, context);
            if nextrec.Rectype = Ihbr.End_Of_File_Rec then
               exit;
            end if;
            if nextrec.Rectype = Ihbr.Data_Rec and then nextrec.DataRecLen > 0
            then
               Ihbr.PutNext (ihbroutfile, nextrec);
            end if ;
         end;
      end loop;
      Ihbr.Close (ihbroutfile);
   end Save;

   procedure Write (filename : String; module : module_type) is
      Block_Size : Stream_Element_Count :=
        Stream_Element_Count (module.all'Length);
      block : Stream_Element_Array (1 .. Block_Size);
      for block'Address use module.all'Address;
      binfile : Stream_IO.File_Type;
   begin
      Stream_IO.Create
        (File => binfile,
         Mode => Stream_IO.Out_File,
         Name => filename);
      Stream_IO.Write (binfile, block);
      Stream_IO.Close (binfile);
   end Write;
end Prom;
