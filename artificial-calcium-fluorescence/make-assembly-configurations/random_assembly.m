function [ output_args ] = random_assembly( v , S , n , N )
%RANDOM_ASSEMBLY( v , S , n , N )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

T = hexagonal_tiling( v );
m = @( x ) sqrt( x(1) ) * [ cos( 2 * pi * x(2) ) sin( 2 * pi * x(2) ) ];

uniform_transform = @( x , X ) ( max( X ) - min( X ) ) .* x + min( X );

for r = 1:N
	
	X = mvnrnd( ( sqrt(3) * v / 2 ) * m( rand(1,2) ) , uniform_transform( rand() , S )^2 * eye(2) , n );
	D = pdist2( X , cell2mat( T ) , 'euclidean' );
	
	output_args{r} = cell_union( cellfun( @( d ) find( d < 0.5 ) , num2cell( D , 2 ) , 'UniformOutput' , false ) );
	
end

end