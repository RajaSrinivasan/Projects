generic
    type context_type is private ;
procedure dirwalk( context : context_type ;
                   dirname : string ;
                   pattern : string ;
                   processor : access procedure ( context : context_type ;
                                                  filename : in string )
                   ) ;
