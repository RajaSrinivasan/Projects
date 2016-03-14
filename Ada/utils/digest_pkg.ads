package digest_pkg is
    BLOCKSIZE : constant := 1024 ;
    function digest_md5( filename : string ) return string ;
    procedure digest_md5( dirname : string ;
                          pattern : string ) ;
    function digest_sha( filename : string ;
                         level : integer := 1 ) return string ;
    procedure digest_sha( dirname : string ;
                          pattern : string ;
                          level : integer := 1) ;
end digest_pkg ;
