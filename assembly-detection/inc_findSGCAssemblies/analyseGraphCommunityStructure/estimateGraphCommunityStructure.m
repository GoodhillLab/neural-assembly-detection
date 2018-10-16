function [ output_args ] = estimateGraphCommunityStructure( graph , opts )
%ESTIMATEGRAPHCOMMUNITYSTRUCTURE( graph , opts ) Wrapper function for the
%'estimate' function to run the Marko-Chain-Monte-Carlo procedure for
%estimating community structure.
%
%   INPUT:
%   graph [graph]: undirected, unweigted graph
%   opts [struct]: (optional) parameters of the algorithm
%       .MonteCarloSteps [scalar]: number of steps in every MCMC run (default: 10000)
%       .RNGSeed [scalar]: seed for the random number generator (default: NaN)
%       .maximalK [scalar]: maximal number of communities (default: 40)
%       .initialK [scalar]: initial guess for the number of communities (default: NaN)
%       .showBanner [boolean]: show banner (default: false)
%       
%   OUTPUT:
%   output_args [1x? struct]: results
%       .k [scalar]: number of communities
%       .g [1x? matrix]: community assignment
%       .E [scalar]: log-likelihood
%
%   EXAMPLES:
%   estimateGraphCommunityStructure( ZacharyKarateClub , struct() )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk(2,2);

if( ~isa( graph , 'graph' ) )
	error( 'Invalid input.' );
end

opts_ = struct();
for opt = transpose( fieldnames( opts ) )
	switch opt{:}
		case 'MonteCarloSteps'
			opts_.MCsweeps = opts.MonteCarloSteps;
		case 'RNGSeed'
			opts_.seed = opts.RNGSeed;
		case 'maximalK'
			opts_.K = opts.maximalK;
		case 'initialK'
			opts_.K0 = opts.initialK;
	end
end

STD_OPTS = struct( 'K' , 40 , 'K0' , NaN , 'seed' , NaN , 'MCsweeps' , 10000 ,'verbose' , 1 );
for opt = { 'K' , 'K0' , 'seed' , 'MCsweeps' , 'verbose' }
	if( ~isfield( opts_ , opt{:} ) )
		opts_.( opt{:} ) = STD_OPTS.( opt{:} );
	end
end

if( isnan( opts_.K0 ) )
	opts_.K0 = randi( opts_.K );
else
	opts_.K0 = min( opts_.K , opts_.K0 );
end

if( isfield( opts , 'showBanner' ) )
	if( opts.showBanner == true )
		
		fprintf( 1 , [ '\n' ] );
		
		fprintf( 1 , [ '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' '\n' ] );
		fprintf( 1 , [ '+                                                                              +' '\n' ] );
		fprintf( 1 , [ '+           estimate   ||   Newman, Reinert 2016 ; Phys.Rev.Lett 117           +' '\n' ] );
		fprintf( 1 , [ '+                                                                              +' '\n' ] );
		fprintf( 1 , [ '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++' '\n' ] );
		
		fprintf( 1 , [ '\n' ] );
		
	end
end

output_args = estimate( graph , opts_ );


switch( 2 ^ ( 2 + find( log2( opts_.K ) < 2 .^ ( 2 + [ 1:4 ] ) , 1, 'first' ) ) )
	case 8
		uint = @(u) uint8( u );
	case 16
		uint = @(u) uint16( u );
	case 32
		uint = @(u) uint32( u );
	case 64
		uint = @(u) uint64( u );
end

for s = 1:numel( output_args )
	output_args(s).k = uint( output_args(s).k );
	output_args(s).g = uint( normalisePatternEnumeration( output_args(s).g ) );
end

end
