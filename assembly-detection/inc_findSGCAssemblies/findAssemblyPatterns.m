function [ output_args ] = findAssemblyPatterns( activityPatterns )
%FINDASSEMBLYPATTERNS( activityPatterns )
%
%   INPUT:
%   activityPatterns [1x? cell]: cell array of binary activity patterns
%
%   EXAMPLE:
%   findAssemblyPatterns( num2cell( [ sort( randi( [0,1] , 20 , 40 ) , 2 , 'ascend' ) ; sort( randi( [0,1] , 20 , 40 ) , 2 , 'descend' ) ] , 2 ) )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

	output_args.activityPatterns = activityPatterns;

%% > BUILD SIMILARITY GRAPH
	printConsoleSection( 'BUILD SIMILARITY GRAPH' );
	
	fprintf( 1 , [ '%i activity patterns' '\n' ] , numel( activityPatterns ) );
	fprintf( 1 , [ '\n' ] );
	
	if( numel( activityPatterns ) == 0 )
		return;
	end
	
	patternSimilarityGraph = buildPatternSimilarityGraph( activityPatterns );
	%output_args.patternSimilarityGraph = patternSimilarityGraph;
	
%% > ANALYSE COMMUNITY STRUCTURE IN SIMILARITY GRAPH
	printConsoleSection( 'ANALYSE COMMUNITY STRUCTURE IN SIMILARITY GRAPH' );
	
	N_ITERATIONS = 5;
	N_MONTECARLOSTEPS = 50000;
		
	patternSimilarityAnalysis = analyseGraphCommunityStructure( patternSimilarityGraph , struct( 'Iterations' , N_ITERATIONS , 'MonteCarloSteps' , N_MONTECARLOSTEPS , 'initialK' , NaN ) );
	output_args.patternSimilarityAnalysis = patternSimilarityAnalysis;
	
	
%% > INFER ASSEMBLY PATTERNS
	printConsoleSection( 'INFER ASSEMBLY PATTERNS' );
	
	[ assemblyPatterns , iAssemblyPatterns ] = inferAssemblyPatterns( activityPatterns , patternSimilarityAnalysis );
	
	output_args.assemblyActivityPatterns = assemblyPatterns;
	output_args.assemblyIActivityPatterns = iAssemblyPatterns;

	fprintf( 1 , [ '   %i assembly patterns' '\n' ] , numel( assemblyPatterns ) );
	fprintf( 1 , [ '\n' ] );
	
end

