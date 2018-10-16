function [ assemblyPatterns , iAssemblyPatterns ] = inferAssemblyPatterns( activityPatterns , patternSimilarityAnalysis )
%INFERASSEMBLYPATTERNS( activityPatterns , patternSimilarityAnalysis )
%
%   INPUT:
%   activityPatterns [1x? cell]: cell array of binary activity patterns
%   patternSimilarityAnalysis [struct]: pattern similarity analysis results
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

MINIMUM_SIZE = 5;
STD_DEVIATIONS = 1.5;

ACTIVTY_THRESHOLD = 0.2;


cosineDistance = @( x_1 , x_2 ) ( 1 - ( ctranspose( x_1 ) * x_2 ) / ( norm( x_1 ) * norm( x_2 ) ) );

%% PERFORM SPECTRAL CLUSTERING ON THE SIMILARITY GRAPH

gAssignment = spectralclustering( patternSimilarityAnalysis.graph , patternSimilarityAnalysis.communityStructure.count , 'normalised' );

%% DISREGARD COMMUNITIES CONSISTING OF TOO FEW ACTIVITY PATTERNS

discriminateSize()

%% DEFINE PRELIMINARY CORE ASSEMBLY PATTERNS

prelimAssemblyPatterns = cell( max( gAssignment ) , 1 );

for r = 1:numel( prelimAssemblyPatterns )
	if( any( gAssignment == r ) )
		prelimAssemblyPatterns{ r } = meanActivityPattern( activityPatterns( gAssignment == r ) , ACTIVTY_THRESHOLD );
		prelimAssemblyPatterns{ r } = double( prelimAssemblyPatterns{ r } ~= 0 );
	else
		prelimAssemblyPatterns{ r } = zeros( size( activityPatterns{ 1 } ) );
	end
end

%% COMBINE SIMILAR PRELIMINARY CORE ASSEMBLY PATTERNS

p = ( 2 / 3 );

prelimAssemblyPatternsSimilarity = cross_evaluation( @(x,y) ( min( ( x * ctranspose( y ) ) / norm( y )^2 , ( y * ctranspose( x ) ) / norm( x )^2 ) > p ) , prelimAssemblyPatterns );

[ R , S ] = ind2sub( size( prelimAssemblyPatternsSimilarity ) , find( triu( prelimAssemblyPatternsSimilarity , 1 ) ) );
for i = 1:sum( sum( triu( prelimAssemblyPatternsSimilarity , 1 ) ) )
	gAssignment( gAssignment == S(i) ) = R(i);
	
	% CHANGE THE REASSIGNMENT RECURSIVELY
	R( i + find( R( i+1:end ) == S(i) ) ) = R(i);
end

% RE-DEFINE PRELIMINARY CORE ASSEMBLY PATTERNS FROM THE CHANGED GROUP ASSIGNMENT

for r = 1:numel( prelimAssemblyPatterns )
	if( any( gAssignment == r ) )
		prelimAssemblyPatterns{ r } = meanActivityPattern( activityPatterns( gAssignment == r ) , ACTIVTY_THRESHOLD );
		prelimAssemblyPatterns{ r } = double( prelimAssemblyPatterns{ r } ~= 0 );
	else
		prelimAssemblyPatterns{ r } = zeros( size( activityPatterns{ 1 } ) );
	end
end

%% ASSIGN EVERY ACTIVITY TO A GROUP DEFINED BY A PRELIMINARY CORE ASSEMBLY PATTERN
% IF THE PATTERNS DO NOT EXCEED A CERTAIN LEVEL OF SIMILARITY THEY WILL BE DISREGARDED

p = ( 1 / 2 );

% H = figure();
for j = 1:numel( gAssignment )
	x = activityPatterns{j};
	[ ~ , r ] = min( cellfun( @(a) cosineDistance( transpose( a ) , transpose( x ) ) , prelimAssemblyPatterns , 'UniformOutput' , true ) );
	
    if( ~isempty( r ) )
    
        % REQUIRE F TO OVERLAP WITH AN CORE_ASSEMBLY TO AT LEAST p IN ORDER TO ASSOCIATE IT WITH IT
        % vvvvv DOES NOT WORK WITH MANY UNITS vvvv
        % gAssignment(j) = iif( ( prelimAssemblyPatterns{ r } * transpose( x ) > p * norm( x )^2 ) && ( norm( x )^2 > p * norm( prelimAssemblyPatterns{ r } )^2 ) , r , uint8( NaN ) );
        % vvvvv IMPROVEMENT vvvv
        gAssignment(j) = iif( ( prelimAssemblyPatterns{ r } * transpose( x ) > p * norm( prelimAssemblyPatterns{ r } )^2 ) && ( norm( x )^2 > p * norm( prelimAssemblyPatterns{ r } )^2 ) , r , uint8( NaN ) );

    else
        gAssignment(j) = 0;
    end
    
    if( gAssignment(j) ~= 0 )
%         H.Name = [ num2str( j ) ' : ' iif( gAssignment(j) ~= 0 , 'accepted' , 'REJECTED' ) ];
%         subplot( 1 , 2 , 1 );
%         tikz_tectaltopologyplot( 12 * cell2mat( hexagonal_tiling( 16 ) ) , NaN , prelimAssemblyPatterns{r} , struct( 'reference_plot' , true , 'centre_of_mass' , false , 'assembly_boundary' , false ) , true );
%         subplot( 1 , 2 , 2 );
%         tikz_tectaltopologyplot( 12 * cell2mat( hexagonal_tiling( 16 ) ) , NaN , x , struct( 'reference_plot' , false , 'centre_of_mass' , false , 'assembly_boundary' , false ) , true );
%         disp( j );
    end
end


%% DISREGARD COMMUNITIES CONSISTING OF TOO FEW ACTIVITY PATTERNS

discriminateSize()

%% DEFINE CORE ASSEMBLY PATTERNS

assemblyPatterns = cell( max( gAssignment ) , 1 );
iAssemblyPatterns = cell( max( gAssignment ) , 1 );

for r = 1:numel( assemblyPatterns )
	if( any( gAssignment == r ) )
		iAssemblyPatterns{ r } = find( gAssignment == r );
		assemblyPatterns{ r } = meanActivityPattern( activityPatterns( iAssemblyPatterns{ r } ) , ACTIVTY_THRESHOLD );
	end
end

I = ~cellfun( @isempty , assemblyPatterns );

iAssemblyPatterns = iAssemblyPatterns( I );
assemblyPatterns = assemblyPatterns( I );



	function discriminateSize()
		
		minSize = max( 0, cellfun( @(h) mean( h ) - STD_DEVIATIONS * std( h ) , { histc( gAssignment , setdiff( unique( gAssignment ) , uint8( NaN ) ) ) } ) );
		minSize = max( MINIMUM_SIZE , minSize );
		
		for r_ = setdiff( unique( gAssignment ) , uint8( NaN ) )
			if( sum( gAssignment == r_ ) < minSize )
				gAssignment( gAssignment == r_ ) = uint8( NaN );
			end
		end
	end

end

