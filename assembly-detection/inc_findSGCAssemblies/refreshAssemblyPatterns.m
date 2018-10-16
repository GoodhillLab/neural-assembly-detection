function [ output_args ] = refreshAssemblyPatterns( input_args )
%REFRESHASSEMBLYPATTERNS( input_args )
%
%   INPUT:
%   input_args [struct]: findAssemblyPattern output
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

    output_args = input_args;
	
%% > RE-ANALYSE COMMUNITY STRUCTURE IN SIMILARITY GRAPH
	printConsoleSection( 'RE-ANALYSE COMMUNITY STRUCTURE IN SIMILARITY GRAPH' );
	
	[ k , k_distribution , g ] = computeGraphCommunityStructureMarginals( output_args.patternSimilarityAnalysis.communityStructure.markovChainMonteCarloSamples );
	
	output_args.patternSimilarityAnalysis.('communityStructure').('count') = k;
	output_args.patternSimilarityAnalysis.('communityStructure').('countDistribution') = k_distribution;
	output_args.patternSimilarityAnalysis.('communityStructure').('assignment') = cellfun( @(r) find( g == r ) , num2cell( unique( g ) ) , 'UniformOutput' , false );

	
%% > INFER ASSEMBLY PATTERNS
	printConsoleSection( 'INFER ASSEMBLY PATTERNS' );
	
	[ assemblyPatterns , iAssemblyPatterns ] = inferAssemblyPatterns( output_args.activityPatterns , output_args.patternSimilarityAnalysis );
	
	output_args.assemblyActivityPatterns = assemblyPatterns;
	output_args.assemblyIActivityPatterns = iAssemblyPatterns;

	fprintf( 1 , [ '   %i assembly patterns' '\n' ] , numel( assemblyPatterns ) );
	fprintf( 1 , [ '\n' ] );
	
end

