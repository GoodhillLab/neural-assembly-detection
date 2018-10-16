function [ output_args ] = PROMAX_CS_ASSEMBLY_DETECTION( RASTER_file )
%PROMAX_CS_ASSEMBLY_DETECTION( RASTER_file )
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
    
    fprintf( 1 , [ 'PROMAX_CS_ASSEMBLY_DETECTION( %s )' '\n' ] , RASTER_file );
    fprintf( 1 , [ '\n' ] );
end

if( exist( RASTER_file , 'file' ) == 2 )
		
	printConsoleSection( 'RUN ASSEMBLY DETECTION' );
	
    % if( isdeployed )
        opts.threshold_method = 'circularshift';
        opts.zMax = Inf;
        FindAssemblies( RASTER_file , opts );
    % else
    %   opts.threshold_method = 'circularshift';
    %   FindAssemblies( RASTER_file , opts );
    % end
    AssembliesActivations( strrep( RASTER_file , '_RASTER' , '_PROMAX-CS-ASSEMBLIES' ) );
    
    output_args = load( strrep( RASTER_file , '_RASTER' , '_PROMAX-CS-ASSEMBLIES' ) );
    
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
