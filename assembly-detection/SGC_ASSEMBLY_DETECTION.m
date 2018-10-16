function [ output_args ] = SGC_ASSEMBLY_DETECTION( ACTIVITY_RASTER_file )
%SGC_ASSEMBLY_DETECTION( ACTIVITY_RASTER_file )
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
    
    fprintf( 1 , [ 'SGC_ASSEMBLY_DETECTION( %s )' '\n' ] , ACTIVITY_RASTER_file );
    fprintf( 1 , [ '\n' ] );
end

%% > 

if( exist( ACTIVITY_RASTER_file , 'file' ) == 2 )
    
    if( exist( strrep( ACTIVITY_RASTER_file , '_ACTIVITY-RASTER' , '_SGC-ASSEMBLIES' ) , 'file' ) ~= 2 )
        
        printConsoleSection( 'INITIALISE ASSEMBLY PATTERN DETECTION' );
        
        ACTIVITY_RASTER_mat = load( ACTIVITY_RASTER_file );
        
        activity_patterns = num2cell( ACTIVITY_RASTER_mat.activity_raster( ACTIVITY_RASTER_mat.activity_raster_peaks , : ) , 2 );
        
        printConsoleSection( 'RUN ASSEMBLY PATTERN DETECTION' );
        
        output_args.assembly_pattern_detection = findAssemblyPatterns( activity_patterns );
        
        output_args.assemblies = cellfun( @(a) uint16( find( a ~= 0 ) ) , output_args.assembly_pattern_detection.assemblyActivityPatterns , 'UniformOutput' , false );
        
    else
        
        printConsoleSection( 'INITIALISE ASSEMBLY PATTERN DETECTION' );
        
        output_args = load( strrep( ACTIVITY_RASTER_file , '_ACTIVITY-RASTER' , '_SGC-ASSEMBLIES' ) );
        
        printConsoleSection( 'REDO ASSEMBLY PATTERN DETECTION' );
        
        output_args.assembly_pattern_detection = refreshAssemblyPatterns( output_args.assembly_pattern_detection );
        
        output_args.assemblies = cellfun( @(a) uint16( find( a ~= 0 ) ) , output_args.assembly_pattern_detection.assemblyActivityPatterns , 'UniformOutput' , false );
        
    end
    
    printConsoleSection( 'SAVE RESULTS' );
    
    [ directory , name , ~ ] = fileparts( ACTIVITY_RASTER_file );
    
    OUTPUT_PATH = [ directory '/' strrep( name , '_ACTIVITY-RASTER' , '_SGC-ASSEMBLIES' ) '.mat' ];
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
