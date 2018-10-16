function [ output_args ] = analyseGraphCommunityStructure( graph , opts )
%ANALYSEGRAPHCOMMUNITYSTRUCTURE( graph , opts ) Obtains an estimate for the
%community structure of a given graph.
%
%   These functions implement the approach described in
%   M. E. J. Newman and G. Reinert. "Estimating the number of communities
%   in a network". Phys. Rev. Lett. 117 (2016).
%
%   INPUT:
%   graph [graph]: undirected, unweigted graph
%   opts [struct]: (optional) parameters of the algorithm
%       .Iterations [scalar]: number of independent MCMC runs (default: 1)
%       .MonteCarloSteps [scalar]: number of steps in every MCMC run (default: 10000)
%       .RNGSeed [scalar]: seed for the random number generator (default: NaN)
%       .initialK [scalar]: initial guess for the number of communities (default: NaN)
%       
%   OUTPUT:
%   output_args [struct]: results
%       .graph [graph]: undirected, unweigted graph (same as
%       input)
%       .communityStructure.count [scalar]: most likely number of
%       communities
%       .communityStructure.countDistribution [?x2 matrix]: probability
%       distribution for the number of communities
%       .communityStructure.assignment [1xk cell]: proposed community
%       structure given the most likely number of communities
%       .communityStructure.markovChainMonteCarloSamples [?x1 cell]: MCMC
%       samples
%
%   EXAMPLES:
%   analyseGraphCommunityStructure( ZacharyKarateClub , struct( 'Iterations' , 1 , 'MonteCarloSteps' , 10000 , 'initialK' , 3 ) )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk(1,2);
if( nargin == 1 )
	opts = struct();
end

if( ~isa( graph , 'graph' ) )
	error( 'Invalid input.' );
end

opts_ = struct();
for opt = transpose( fieldnames( opts ) )
	switch opt{:}
		case 'MonteCarloSteps'
			opts_.MonteCarloSteps = opts.MonteCarloSteps;
		case 'RNGSeed'
			opts_.RNGSeed = opts.RNGSeed;
		case 'initialK'
			opts_.initialK = opts.initialK;
	end
end

if( ~isfield( opts , 'Iterations' ) )
	opts.Iterations = 1;
end

STD_OPTS = struct( 'MonteCarloSteps' , 10000 , 'RNGSeed' , NaN , 'maximalK' , ceil( numnodes( graph ) / 3 ) , 'initialK' , NaN , 'showBanner' , false );
for opt = transpose( fieldnames( STD_OPTS ) )
	if( ~isfield( opts_ , opt{:} ) )
		opts_.( opt{:} ) = STD_OPTS.( opt{:} );
	end
end


output_args = NaN;

if( numnodes( graph ) > 0 )
	fprintf( 1 , [ 'Initialising graph community structure estimation ...' '\n' ] );
	
	fprintf( 1 , [ ' Number of vertices: %i\n' ] , numnodes( graph ) );
	fprintf( 1 , [ ' Number of edges: %i\n' ] , numedges( graph ) );
	
	fprintf( 1 , [ '\n' ] );
	
	if( isnan( opts_.RNGSeed ) )
		opts_.RNGSeed = seed_devrandom();
	end
	
	if( opts.Iterations > 1 )
		fprintf( 1 , [ 'Running graph community structure estimation (' num2str( opts.Iterations ) ' iterations) ...' '\n' ] );
	else
		fprintf( 1 , [ 'Running graph community structure estimation ...' '\n' ] );
	end
	
	fprintf( 1 , [ '\n' ] );
	
	% estimation_samples = estimateGraphCommunityStructure( graph , opts_ );
	try
		estimation_samples = cell( opts.Iterations , 1 );
		for i = 1:opts.Iterations
			timer = tic;
			estimation_samples{i} = estimateGraphCommunityStructure( graph , opts_ );
			
			if( opts.Iterations > 1 )
				fprintf( 1 , [ ' Iteration %i completed: %s' '\n' ] , i , print_timeinterval( toc( timer ) ) );
			end
		end
		
		fprintf( 1 , [ '\n' ] );
		fprintf( 1 , [ 'Graph community structure estimation completed.' '\n' ] );
		fprintf( 1 , [ '\n' ] );
	catch
		fprintf( 1 , [ '\n' ] );
		fprintf( 1 , [ 'Graph community structure estimation failed.' '\n' ] );
		fprintf( 1 , [ '\n' ] );
		
		return;
	end
	
	[ k , k_distribution , g ] = computeGraphCommunityStructureMarginals( estimation_samples );
	
	output.('graph') = graph;
	output.('communityStructure').('count') = k;
	output.('communityStructure').('countDistribution') = k_distribution;
	output.('communityStructure').('assignment') = cellfun( @(r) find( g == r ) , num2cell( unique( g ) ) , 'UniformOutput' , false );
	
	output.('communityStructure').('markovChainMonteCarloSamples') = estimation_samples;
	
	output_args = output;
end

end
