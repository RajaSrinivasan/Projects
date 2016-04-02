with System ;
with Interfaces.C ;
with Ada.Streams ;
with Ada.Streams.Stream_Io ;
with Ada.Text_Io ; use Ada.Text_Io ;
with GNAT.MD5 ;
with GNAT.SHA1 ;
with GNAT.SHA224 ;
with GNAT.SHA256 ;
with GNAT.SHA384 ;
with GNAT.SHA512 ;

with Hex ;
with Zlib.Checksums ;

with dirwalk ;

package body digest_pkg is

   procedure dirwalk_md5 is new dirwalk( integer ) ;
   procedure dirwalk_sha is new dirwalk( integer ) ;
   procedure Dirwalk_Crc32 is new Dirwalk( Integer ) ;
   
   function digest_md5( filename : string ) return String is
       use Ada.Streams ;
       f : ada.Streams.Stream_IO.File_Type ;
       buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
       bufbytes : ada.Streams.Stream_Element_Count ;
       bytes : ada.Streams.Stream_Element_Count := 0 ;
       C : Gnat.MD5.Context := Gnat.Md5.Initial_Context ;
    begin
       ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
       while not ada.Streams.Stream_IO.End_Of_File(f)
       loop
          ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
          Gnat.MD5.Update(C,Buffer(1..Bufbytes)) ;
          bytes := bytes + bufbytes ;
       end loop ;
       ada.Streams.Stream_IO.Close(f) ;
       return Gnat.MD5.Digest(C) ;
        exception
           when others =>
              put("Unable to generate md5 digest for ");
              put_line(filename) ;
              return "" ;
    end digest_md5 ;
    procedure digest_md5( context : integer ; filename : string ) is
    begin
        put("File : ");
        put_line( filename );
        put("MD5  : ");
        put( digest_md5(filename)) ;
        new_line ;
    end digest_md5 ;
    procedure digest_md5( dirname : string ;
                          pattern : string ) is
    begin
        dirwalk_md5( 0 , dirname , pattern , digest_md5'access) ;
    end digest_md5 ;

    function digest_sha1( filename : string ) return String is
        use Ada.Streams ;
        f : ada.Streams.Stream_IO.File_Type ;
        buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
        bufbytes : ada.Streams.Stream_Element_Count ;
        bytes : ada.Streams.Stream_Element_Count := 0 ;
        Csha1 : Gnat.SHA1.Context := Gnat.SHA1.Initial_Context ;
     begin
        ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
        while not ada.Streams.Stream_IO.End_Of_File(f)
        loop
           ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
           Gnat.SHA1.Update(Csha1,Buffer(1..Bufbytes)) ;
           bytes := bytes + bufbytes ;
        end loop ;
        ada.Streams.Stream_IO.Close(f) ;
        return Gnat.SHA1.Digest(Csha1) ;
         exception
            when others =>
               put("Unable to generate sha1 digest for ");
               put_line(filename) ;
               return "" ;
     end digest_sha1 ;

     function digest_sha224( filename : string ) return String is
         use Ada.Streams ;
         f : ada.Streams.Stream_IO.File_Type ;
         buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
         bufbytes : ada.Streams.Stream_Element_Count ;
         bytes : ada.Streams.Stream_Element_Count := 0 ;
         Csha224 : Gnat.SHA224.Context := Gnat.SHA224.Initial_Context ;
      begin
         ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
         while not ada.Streams.Stream_IO.End_Of_File(f)
         loop
            ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
            Gnat.SHA224.Update(Csha224,Buffer(1..Bufbytes)) ;
            bytes := bytes + bufbytes ;
         end loop ;
         ada.Streams.Stream_IO.Close(f) ;
         return Gnat.SHA224.Digest(Csha224) ;
          exception
             when others =>
                put("Unable to generate sha224 digest for ");
                put_line(filename) ;
                return "" ;
      end digest_sha224 ;

      function digest_sha256( filename : string ) return String is
          use Ada.Streams ;
          f : ada.Streams.Stream_IO.File_Type ;
          buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
          bufbytes : ada.Streams.Stream_Element_Count ;
          bytes : ada.Streams.Stream_Element_Count := 0 ;
          Csha256 : Gnat.SHA256.Context := Gnat.SHA256.Initial_Context ;
       begin
          ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
          while not ada.Streams.Stream_IO.End_Of_File(f)
          loop
             ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
             Gnat.SHA256.Update(Csha256,Buffer(1..Bufbytes)) ;
             bytes := bytes + bufbytes ;
          end loop ;
          ada.Streams.Stream_IO.Close(f) ;
          return Gnat.SHA256.Digest(Csha256) ;
           exception
              when others =>
                 put("Unable to generate sha256 digest for ");
                 put_line(filename) ;
                 return "" ;
       end digest_sha256 ;

       function digest_sha384( filename : string ) return String is
           use Ada.Streams ;
           f : ada.Streams.Stream_IO.File_Type ;
           buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
           bufbytes : ada.Streams.Stream_Element_Count ;
           bytes : ada.Streams.Stream_Element_Count := 0 ;
           Csha384 : Gnat.SHA384.Context := Gnat.SHA384.Initial_Context ;
        begin
           ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
           while not ada.Streams.Stream_IO.End_Of_File(f)
           loop
              ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
              Gnat.SHA384.Update(Csha384,Buffer(1..Bufbytes)) ;
              bytes := bytes + bufbytes ;
           end loop ;
           ada.Streams.Stream_IO.Close(f) ;
           return Gnat.SHA384.Digest(Csha384) ;
            exception
               when others =>
                  put("Unable to generate sha384 digest for ");
                  put_line(filename) ;
                  return "" ;
        end digest_sha384 ;

        function digest_sha512( filename : string ) return String is
            use Ada.Streams ;
            f : ada.Streams.Stream_IO.File_Type ;
            buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
            bufbytes : ada.Streams.Stream_Element_Count ;
            bytes : ada.Streams.Stream_Element_Count := 0 ;
            Csha512 : Gnat.SHA512.Context := Gnat.SHA512.Initial_Context ;
         begin
            ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
            while not ada.Streams.Stream_IO.End_Of_File(f)
            loop
               ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
               Gnat.SHA512.Update(Csha512,Buffer(1..Bufbytes)) ;
               bytes := bytes + bufbytes ;
            end loop ;
            ada.Streams.Stream_IO.Close(f) ;
            return Gnat.SHA512.Digest(Csha512) ;
             exception
                when others =>
                   put("Unable to generate sha512 digest for ");
                   put_line(filename) ;
                   return "" ;
         end digest_sha512 ;

    function digest_sha( filename : string ;
                         level : integer := 1 ) return string is
    begin
        case level is
            when 1 => return digest_sha1( filename );
            when 224 => return digest_sha224( filename );
            when 256 => return digest_sha256( filename );
            when 384 => return digest_sha384( filename );
            when 512 => return digest_sha512( filename );
            when others =>
                 raise Program_Error ;
        end case ;
    end digest_sha ;

    procedure digest_sha( context : integer ;
                          filename : string ) is
    begin
        put("File : ") ; put_line( filename );
        case context is
            when 1 => put("SHA1 : ");
                      put_line(digest_sha1( filename ));
            when 224 => put("SHA224 : ");
                        put_line(digest_sha224( filename ));
            when 256 => put("SHA256 : ");
                        put_line(digest_sha256( filename ));
            when 384 => put("SHA384 : ");
                        put_line(digest_sha384( filename ));
            when 512 => put("SHA512 : ");
                        put_line(digest_sha512( filename ));
            when others =>
                 raise Program_Error ;
        end case ;
    end digest_sha ;
    procedure digest_sha( dirname : string ;
                          pattern : string ;
                          level : integer := 1) is
    begin
        dirwalk_sha( level , dirname , pattern , digest_sha'access) ;
    end digest_sha ;
    
    function adler32_csum( filename : string ) return string is
    begin
       return "" ;
    end Adler32_Csum ;
    
    procedure adler32_csum( dirname : string ;
                            pattern : string ) is
    begin
       null ;
    end Adler32_cSum ;


    function crc32_csum( filename : string ) return string is
       use Ada.Streams ;
       f : ada.Streams.Stream_IO.File_Type ;
       buffer : ada.Streams.Stream_Element_Array(1..BLOCKSIZE) ;
       bufbytes : ada.Streams.Stream_Element_Count ;
       bytes : ada.Streams.Stream_Element_Count := 0 ;

       Csum : Interfaces.C.Unsigned_Long := 0 ;
    begin
       Csum := Zlib.Checksums.Crc32( Csum , System.Null_Address , 0 );
       ada.Streams.stream_io.Open(f , ada.streams.Stream_IO.In_File , filename ) ;
       while not ada.Streams.Stream_IO.End_Of_File(f)
       loop
          ada.Streams.stream_io.Read(f,buffer,bufbytes) ;
          Csum := Zlib.Checksums.Crc32( Csum , Buffer'Address , Interfaces.C.Unsigned_Long(Bufbytes)) ;
          bytes := bytes + bufbytes ;
       end loop ;
       ada.Streams.Stream_IO.Close(f) ;
       return Hex.Image( Interfaces.Unsigned_32(Csum) ) ;
        exception
           when others =>
              put("Unable to generate md5 digest for ");
              put_line(filename) ;
              return "" ;
    end Crc32_Csum ;
    
    procedure Crc32_Csum( Context : Integer ;
			  Filename : String ) is
    begin
       Put("File : ") ; Put( Filename ) ; Put(" : "); Put_Line( Crc32_Csum( Filename ) ) ;
    end Crc32_Csum ;
    
    procedure crc32_csum( dirname : string ;
                          pattern : string ) is
       Context : Integer := 0 ;
    begin
       dirwalk_crc32( Context , dirname , pattern , Crc32_csum'access) ;
    end Crc32_Csum ;
    
end digest_pkg ;
