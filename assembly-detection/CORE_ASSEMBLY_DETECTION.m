function [ output_args ] = CORE_ASSEMBLY_DETECTION( SPIKE_PROBABILITY_RASTER_file )
%CORE_ASSEMBLY_DETECTION( SPIKE_PROBABILITY_RASTER_file )
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
    
    fprintf( 1 , [ 'CORE_ASSEMBLY_DETECTION( %s )' '\n' ] , SPIKE_PROBABILITY_RASTER_file );
    fprintf( 1 , [ '\n' ] );
end

%% >

if( exist( SPIKE_PROBABILITY_RASTER_file , 'file' ) == 2 )
    
    SPIKE_PROBABILITY_RASTER_mat = load( SPIKE_PROBABILITY_RASTER_file );
    
    output_args = findCOREassemblies( SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster , SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_thresholds( [ SPIKE_PROBABILITY_RASTER_mat.spike_probability_raster_thresholds.p ] == 0.05 ).coactivity );
    
    printConsoleSection( 'SAVE RESULTS' );
    
    [ directory , name , ~ ] = fileparts( SPIKE_PROBABILITY_RASTER_file );
    
    OUTPUT_PATH = [ directory '/' strrep( name , '_SPIKE-PROBABILITY-RASTER' , '_CORE-ASSEMBLIES' ) '.mat' ];
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
