with ada.Text_Io; use Ada.Text_Io ;
with Ada.integer_text_Io; use Ada.integer_text_io ;
with Ada.Strings.unbounded ; use Ada.Strings.unbounded ;

with digest_cli ;                            -- [cli/$_cli]
with digest_pkg ;

procedure digest is                  -- [clitest/$]
begin
   digest_cli.ProcessCommandLine ;           -- [cli/$_cli]
   if digest_cli.Verbose
   then
       if digest_cli.md5_alg
       then
          Put(" md5 algorithm requested; ");
       end if ;
       if digest_cli.sha_alg
       then
         Put(" sha algorithm requested with level ") ;
         put( digest_cli.sha_level ) ;
       end if ;
       new_line ;
       if digest_cli.recursive
       then
          put_line("Will recurse into the directory specified ") ;
          if digest_cli.filepattern /= null_unbounded_string
          then
             put("Will search for files of the pattern ");
             put_line( to_string( digest_cli.filepattern)) ;
          end if ;
       else
          put_line("Will generate the digest of the files") ;
       end if ;
   end if ;

   if not digest_cli.recursive
   then
       loop
           declare
               file : string := digest_cli.GetNextArgument ;
           begin
               if file'length = 0
               then
                  exit ;
               end if ;
               put("File :"); put_line(file) ;
               if digest_cli.md5_alg
               then
                   put("MD5 : "); put_line( digest_pkg.digest_md5( file )) ;
               end if ;
               if digest_cli.sha_alg
               then
                    put("SHA") ; put(digest_cli.sha_level) ; put( " : ");
                    put_line(digest_pkg.digest_sha(file , digest_cli.sha_level )) ;
               end if ;
	       if Digest_Cli.Crc32_Alg
	       then
		  Put("CRC32 : ") ;Put_Line( Digest_Pkg.Crc32_csum(File) ) ;
	       end if ;
	       if Digest_Cli.Adler_Alg
	       then
		  Put("Adler32 : ") ;Put_Line( Digest_Pkg.Adler32_csum(File) ) ;
	       end if ;
           end ;
       end loop ;
   else
       if digest_cli.md5_alg
       then
           digest_pkg.digest_md5( digest_cli.GetNextArgument , to_string(digest_cli.filepattern) ) ;
       end if ;
       if digest_cli.sha_alg
       then
           digest_pkg.digest_sha( digest_cli.GetNextArgument
                                , to_string(digest_cli.filepattern)
                                , digest_cli.sha_level);
       end if ;
       if Digest_Cli.Crc32_Alg
       then
	  Digest_Pkg.Crc32_csum( Digest_Cli.GetNextArgument
				     , To_String(Digest_Cli.Filepattern) ) ;
	  
       end if ;			     
       if Digest_Cli.Adler_Alg
       then
	  Digest_Pkg.Adler32_csum( Digest_Cli.GetNextArgument
				     , To_String(Digest_Cli.Filepattern) ) ;
	  
       end if ;			     
   end if ;
end digest ;                         -- [clitest/$]
