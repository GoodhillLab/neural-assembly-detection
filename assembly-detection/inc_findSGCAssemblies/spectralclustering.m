function [ output_args ] = spectralclustering( G , K , normalisation )
%SPECTRALCLUSTERING( G , K , normalisation ) Performs spectral clustering
%on the graph G into k clusters.
%
%   INPUT:
%   G [graph]: input graph
%   K [1x? matrix]: number of clusters
%   h [Nx1 matrix]: external field
%   n [scalar]: number of states
%   normalisation [string]: (optional) spectral clustering normalisation
%   ('unnormalised','symmetric','randomwalk'/'normalised')
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

if( nargin < 3 )
	normalisation = '';
end

optimisation = false;

% =========================================================================

z = 1;
H = graphlaplacian( G , normalisation ) + z * eye( numnodes( G ) );
% In H the spectrum was shifted by an amount z away from 0 in order for the
% matrix to be non-singular so that the computation of eigenvectors tends
% to be more stable.

[ U_ , e_ ] = eig( H , 'vector' );
[ e_ , iex ] = sort( e_ , 'ascend' );

output_args = NaN * ones( numel( K ) , numnodes( G ) );

for j = 1:numel( K )
	k = K(j);
	
	e = e_( 1:k );
	U = U_( : , iex( 1:k ) );
	
	% =========================================================================
	
	if( isreal( U ) && max( max( abs( H * U - U * diag( e ) ) ) ) < 1e-10 )
		
		switch( normalisation )
			case { '' , 'unnormalised' }
				
			case 'symmetric'
				U = normr( U );
			case { 'randomwalk' , 'normalised' }
				
		end
		
		V = uint16( 1:numnodes( G ) );
		
		idx = transpose( kmeans( U , k , 'Distance' , 'sqeuclidean' , 'Replicates' , 100 ) );
		idx = normalisePatternEnumeration( idx );
		
		output_args_k = cell( k , 1 );
		for r = 1:k
			output_args_k{r} = V( idx == r );
		end
		
		
		if( optimisation && any( strcmp( normalisation , { 'randomwalk' , 'normalised' } ) ) )
			output_args_k = ncutoptimisation( G , output_args_k );
		end
		
		[ ~ , iO ] = sort( cellfun( 'size' , output_args_k , 2 ) , 'descend' );
		output_args_k = output_args_k( iO );
		
		output_args(j,:) = uint8( assignmentvector( G , output_args_k ) );
		
	else
		fprintf( 1 , [ ' ! Spectral clustering failed.' '\n' ] );
		fprintf( 2 , [ '! Spectral clustering failed.' '\n' ] );
		output_args(j,:) = uint8( zeros( 1, numnodes( G ) ) );
	end
	
end

end

function [ output_args ] = graphlaplacian( G , normalisation )

if( nargin < 2 )
	normalisation = '';
end

A = full( adjacency( G ) );
D = degree( G );

J = eye( numnodes( G ) );

switch( normalisation )
	case { '' , 'unnormalised' }
		d = D;
		output_args = diag( d ) - A;
	case 'symmetric'
		d = 1 ./ sqrt( D );
		output_args = J - diag( d ) * A * diag( d );
	case { 'randomwalk' , 'normalised' }
		d = 1 ./ D;
		output_args = J - diag( d ) * A;
end
end

function [ output_args ] = ncutoptimisation( G , c )

A = full( adjacency( G ) );
D = degree( G );

n = numnodes( G );
K = 1:numel( c );

output_args = c;
t_output_args = c;

change = true;
t = 0;

while( change )
	change = false;
	
	for x=uint16( randperm( n ) )
		
		R = setdiff( K , K( cellfun(@(C) any( C == x ) , output_args ) ) );
		R = R( randperm( numel( R ) ) );
		
		for r=R
			t_output_args = move( output_args , x , r );
			if( ncut( t_output_args ) < ncut( output_args ) )
				output_args = t_output_args;
				
				% disp( x );
				
				change = true;
			end
		end
	end
	
	t = t + 1;
	
	if( t >= 100 )
		fprintf( 2 , [ 'break out of loop' '\n' ] );
		break;
	end
end



	function [ output_args ] = ncut( c )
		
		output_args = zeros( 1 , numel( c ) );
		for j = 1:numel( c )
			output_args(j) = W( c{j} , setdiff( 1:n , c{j} ) ) / vol( c{j} );
		end
		
		output_args = sum( output_args );
		
		function [ output_args ] = vol( ic )
			output_args = sum( D( ic ) );
		end
		
		function [ output_args ] = W( ic1 , ic2 )
			output_args = sum( sum( A( ic1 , ic2 ) ) );
		end
		
	end

	function [ output_args ] = move( c , x , r )
		if( r < numel( c ) )
			for s=1:numel( c )
				c{s} = setdiff( c{s} , [ x ] );
				if( s == r )
					c{s} = sort( [ c{s} x ] );
				end
			end
		end
		
		output_args = c;
	end

end

function [ output_args ] = assignmentvector( G , c )

output_args = zeros( 1, numnodes( G ) );

for j = 1:numel( c )
	output_args( c{j} ) = j;
end

output_args = normalisePatternEnumeration ( output_args );
end