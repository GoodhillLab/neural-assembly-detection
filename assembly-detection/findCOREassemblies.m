function [ output_args ] = findCOREassemblies( spike_probability_raster , spike_probability_coactivity_threshold )
%FINDCOREASSEMBLIES( spike_probability_raster , spike_probability_coactivity_threshold )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

%% > EXTRACT ENSEMBLES
printConsoleSection( 'EXTRACT ENSEMBLES' );

i_ensemble = ( sum( spike_probability_raster , 2 ) > spike_probability_coactivity_threshold );

ensembles = num2cell( spike_probability_raster( i_ensemble , : ) , 2 );
ensembles_raster = cell2mat( ensembles );

pearson_R = corr( ensembles_raster' , 'type' , 'Pearson' );
z_pearson_R = 0.5 * log( ( 1 + pearson_R ) ./ ( 1 - pearson_R ) );

%% > DETERMINE SIGNIFICANT ENSEMBLE SIMILARITY THRESHOLD
printConsoleSection( 'DETERMINE SIGNIFICANT ENSEMBLE SIMILARITY THRESHOLD' );

FULLY_VECTORISED = false;

if( FULLY_VECTORISED )
    
    % ! MEMORY INTESIVE
    
    shuff_pearson_R = zeros( [ 50000 , size( pearson_R ) ] );
    
    timer_ = tic;
    print_progress( 0 , 'initialise' , timer_ );
    for s = 1:size( shuff_pearson_R , 1 )
        
        iN_shuffle = randperm( size( ensembles_raster , 2 ) );
        shuff_pearson_R(s,:,:) = corr( ensembles_raster' , ensembles_raster(:,iN_shuffle)' , 'type' , 'Pearson' );
        
        print_progress( s / size( shuff_pearson_R , 1 ) , 'update' , timer_ );
    end
    print_progress( 1 , 'finalise' , timer_ );
    
    sig_pearson_R = squeeze( prctile( shuff_pearson_R , 95 ) );
    
else
    
    sig_pearson_R = NaN * ones( size( pearson_R ) );
    
    
    if( ~FULLY_VECTORISED )
        
        M = size( sig_pearson_R , 1 );
        n_C = 150;
        
        n_I_clusters = floor( M / ceil( M / n_C ) ) * ones( 1 , ceil( M / n_C ) ) + [ ones( 1 , mod( M , ceil( M / n_C ) ) ) , zeros( 1 , ceil( M / n_C ) - mod( M , ceil( M / n_C ) ) ) ];
        n_I_clusters = n_I_clusters( randperm( numel( n_I_clusters ) ) );
        
        I_values = randperm( M );
        I_clusters = cell( 1 , numel( n_I_clusters ) );
        for t = 1:numel( I_clusters )
            I_clusters{t} = I_values( 1:n_I_clusters(t) );
            I_values = I_values( (n_I_clusters(t)+1):end );
        end
        
    else
        
        I_clusters = { 1:size( sig_pearson_R , 1 ) };
    end
    
    
    for C_i = I_clusters
        for C_j = I_clusters
            
            shuff_pearson_R = zeros( [ 50000 , numel(C_i{:}) , numel(C_j{:}) ] );
            
            for s = 1:size( shuff_pearson_R , 1 )
                
                iN_shuffle = randperm( size( ensembles_raster , 2 ) );
                shuff_pearson_R(s,:,:) = corr( ensembles_raster(C_i{:},:)' , ensembles_raster(C_j{:},iN_shuffle)' , 'type' , 'Pearson' );
            end
            
            sig_pearson_R(C_i{:},C_j{:}) = prctile( shuff_pearson_R , 95 );
        end
    end
    
end

I_sig_pearson_R = ( pearson_R > sig_pearson_R );

output_args.ensemble_detection.ensembles = ensembles;
output_args.ensemble_detection.ensembleSimilarity = pearson_R;
output_args.ensemble_detection.ensembleSimilaritySignificanceThreshold = sig_pearson_R;


%% > FIND CORE ENSEMBLES
printConsoleSection( 'FIND CORE ENSEMBLES' );

CONST.CORE_AFFINITY = 0.5;

cores_ensembles = cellfun( @(I) mean( cell2mat( ensembles( I ) ) , 1 ) >= CONST.CORE_AFFINITY , num2cell( I_sig_pearson_R , 2 ) , 'UniformOutput' , false );
cores_ensembles = cores_ensembles( cellfun( @(C) any( C ) , cores_ensembles ) );
cores_ensembles = num2cell( unique( cell2mat( cores_ensembles ) , 'rows' ) , 2 );

unit_prob = mean( spike_probability_raster );
cores_ensembles_prob = cellfun( @(C) mean( all( spike_probability_raster( : , C ) , 2 ) ) , cores_ensembles );
cores_ensembles_0prob = cellfun( @(C) prod( unit_prob( C ) ) , cores_ensembles );


cores_ensembles = cores_ensembles( cores_ensembles_prob > cores_ensembles_0prob );
cores_ensembles = cellfun( @double , cores_ensembles , 'UniformOutput' , false );
cores_ensembles_raster = cell2mat( cores_ensembles );


output_args.ensemble_detection.coreEnsembles = cores_ensembles;

%% > CLUSTER CORE ENSEMBLES
printConsoleSection( 'CLUSTER CORE ENSEMBLES' );

switch numel( cores_ensembles )
    case 0
        core_ensembles_IClusters = NaN;
        assemblies = {};
    case 1
        core_ensembles_IClusters = { [1] };
        assemblies = { uint16( find( cores_ensembles_raster( 1 , : ) >= 0.5 ) ) };
        
    otherwise
        CONST.SILHOUETTE_ROUNDS = 100;
        
        silhouettes_S = cell( CONST.SILHOUETTE_ROUNDS , 1 );
        
        dist = 'hamming';
        
        timer_ = tic;
        print_progress( 0 , 'initialise' , timer_ );
        for r = 1:numel( silhouettes_S )
            silhouettes_S{r} = arrayfun( @(k) mean( silhouette( cores_ensembles_raster , kmeans( cores_ensembles_raster , k , 'Distance' , dist ) , dist ) ) , 1:ceil( size( cores_ensembles_raster , 1 ) / 4 ) , 'UniformOutput' , true );
            
            print_progress( r / CONST.SILHOUETTE_ROUNDS , 'update' , timer_ );
        end
        print_progress( 1 , 'finalise' , timer_ );
        
        
        % [ silhouettes_S_k , k ] = max( mean( cell2mat( silhouettes_S ) , 1 ) );
        [ ~ , k ] = max( max( cell2mat( silhouettes_S ) , [] , 1 ) );
        
        fprintf( 1 , [ '> optimal number of clusters of core ensembles: %u' '\n' ] , k );
        
        g = ones( 1 , size( cores_ensembles_raster , 1 ) );
        g_S = 0;
        
        for r = 1:CONST.SILHOUETTE_ROUNDS
            g_ = kmeans( cores_ensembles_raster , k , 'Distance' , dist )';
            g_S_ = mean( silhouette( cores_ensembles_raster , g_' , dist ) );
            if( g_S_ > g_S )
                g_S = g_S_;
                g = g_;
            end
        end
        
        
        core_ensembles_IClusters = arrayfun( @(r) find( g == r ) ,  unique( g ) , 'UniformOutput' , false );
        
        assemblies = cellfun( @(I) uint16( find( mean( cores_ensembles_raster( I , : ) ) >= 0.5 ) ) , core_ensembles_IClusters , 'UniformOutput' , false );
        assemblies = assemblies( ~cellfun( @isempty , assemblies ) );
        
end

output_args.ensemble_detection.coreEnsemblesIClusters = core_ensembles_IClusters;
output_args.assemblies = assemblies;

end