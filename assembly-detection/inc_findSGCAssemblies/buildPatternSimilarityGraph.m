function [ output_args ] = buildPatternSimilarityGraph( X )
%BUILDPATTERNSIMILARITYGRAPH( X ) Returns a k-nearest-neighbour graph
%according to the consine distance from the pattern data in X.
%
%   INPUT:
%   X [1x? cell]: cell array of binary activity patterns
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

% k = ceil(log( size( X , 1 ) ));
cosineDistance = @( x , y ) ( 1 - ( ctranspose( x ) * y ) / ( norm( x ) * norm( y ) ) );
% miDistance = @( x , y ) ( 1 - 2 * ( ctranspose( x ) * y ) / ( sum( x ) + sum( y ) ) );

for k = ceil(log( size( X , 1 ) )):size( X , 1 )
	
	knn = k_nearestneighbours( X , k , cosineDistance );
	
	% We select the k nearest neighbours, however in case of a tie, when there
	% are multiple data point with the same distance from a single node, we
	% include all of them:
	
	A = zeros( size( knn , 1 ) );
	for x = 1:size( knn , 1 )
		n = knn{x}( knn{x} ~= x );
		
		A( x , n ) = 1;
		A( n , x ) = 1;
	end
	
	output_args = graph( A );
	
	if( numel( unique( conncomp( output_args ) ) ) == 1 )
		break;
	end
end
	
end

function [ output_args ] = k_nearestneighbours( X , k , d )

output_args = cell( size( X , 1 ) );

dist = cross_evaluation( d , cellfun( @(x) ctranspose( x ) , X , 'UniformOutput' , false ) ) + diag( NaN * ones( 1 , numel( X ) ) );

for i = 1:size( X , 1 )
	s = sort( dist(i,:) );
	
	output_args{i} = find( dist(i,:) <= s( k ) );
end
end
