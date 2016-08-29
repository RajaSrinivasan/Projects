package body Text.SelfTest is
   procedure Test is
   begin
      pragma Assert( Encode( 10 ) = 'K' ) ;
      pragma Assert( Decode( 'K') = 10 ) ;
   end Test ;
end Text.SelfTest ;
