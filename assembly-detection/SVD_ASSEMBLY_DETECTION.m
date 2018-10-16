function [ output_args ] = SVD_ASSEMBLY_DETECTION( SPIKE_PROBABILITY_RASTER_file )
%SVD_ASSEMBLY_DETECTION( SPIKE_PROBABILITY_RASTER_file )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

narginchk(1,1);

fprintf( 1 , [ '\n' ] );

timerVal = tic;

%% > PRINT FUNCTION-CALL
if( isdeployed )
    printConsoleSection( 'FUNCTION CALL' );
    
    fprintf( 1 , [ 'SVD_ASSEMBLY_DETECTION( %s )' '\n' ] , SPIKE_PROBABILITY_RASTER_file );
    fprintf( 1 , [ '\n' ] );
end

%% >

if( exist( SPIKE_PROBABILITY_RASTER_file , 'file' ) == 2 )
    
    SPIKE_PROBABILITY_RASTER_mat = load( SPIKE_PROBABILITY_RASTER_file );
    
    %disp( SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_threshold );
    %I = sum( SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster , 2 ) > SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_threshold;    
    [ core_svd , state_pks_full , ~ ] = findSVDensemble( transpose( SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster ) , NaN , struct( 'pks' , SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_thresholds( [ SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_thresholds.p ] == 0.01 ).coactivity , 'ticut' , [] , 'jcut' , [] , 'state_cut' , [] ) );
    
    output_args.assemblies = cellfun( @(a) uint16( transpose( a ) ) , transpose( core_svd ) , 'UniformOutput' , false );
    output_args.assemblies_activation = transpose( state_pks_full );
    
    
    
    printConsoleSection( 'SAVE RESULTS' );
    
    [ directory , name , ~ ] = fileparts( SPIKE_PROBABILITY_RASTER_file );
    
    OUTPUT_PATH = [ directory '/' strrep( name , '_SPIKE-PROBABILITY-RASTER' , '_SVD-ASSEMBLIES' ) '.mat' ];
    save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
    fileattrib( OUTPUT_PATH , '+w' , 'g' );
    
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
else
    output_args = NaN;
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
end

%% > PRINT TIMING
if( isdeployed )
    printConsoleSection( 'TIMING' );
    
    fprintf( 1 , [ 'Elapsed time (walltime): %.3fs\n' ] , toc(timerVal) );
    
end

end
