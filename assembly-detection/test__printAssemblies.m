


bestmatch_d = @(c1,c2) 1 - numel( intersect( c1 , c2 ) ) / numel( union( c1 , c2 ) );
bestmatch_score = @(A,B) 1 - bestmatch( bestmatch_d , A , B ) / ( 1 * ( numel( A ) + numel( B ) ) );


printConsoleSection( 'EMBEDDED ASSEMBLY CONFIGURATION' );
A_ = CALCIUM_FLUORESCENCE_mat.parameter.assembly_configuration;
A_ = cellfun( @(a) sort( a ) , A_ , 'UniformOutput' , false );
A_ = A_( ~cellfun( @isempty , A_ ) );
for r = 1:numel( A_ )
    
    fprintf( 1 , [ '%4u: { ' strjoin( repmat( {'%5u'} , 1 , numel( A_{r} ) ) , '' ) ' }' '\n' ] , r , A_{r} );
    
end

printConsoleSection( 'INFERRED ASSEMBLY CONFIGURATION' );
for r = 1:numel( A )
    
    fprintf( 1 , [ '%4u: { ' strjoin( repmat( {'%5u'} , 1 , numel( A{r} ) ) , '' ) ' }' '\n' ] , r , A{r} );
    
end

fprintf( 1 , '\n' );
fprintf( 1 , [ '> BestMatch score: %.5f' '\n' ] , bestmatch_score( A , A_ ) );



figure;

imagesc( cross_evaluation( @(c1,c2) bestmatch_d(c1,c2) , A , A_ ) , [ 0 1 ] )

xticks( 1:numel( A_ ) );
yticks( 1:numel( A ) );

axis equal;
axis tight;

