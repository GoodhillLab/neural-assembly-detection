function [ output_args ] = PROMAX_MP_ASSEMBLY_DETECTION( RASTER_file )
%PROMAX_MP_ASSEMBLY_DETECTION( RASTER_file )
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
    
    fprintf( 1 , [ 'PROMAX_MP_ASSEMBLY_DETECTION( %s )' '\n' ] , RASTER_file );
    fprintf( 1 , [ '\n' ] );
end

if( exist( RASTER_file , 'file' ) == 2 )
		
	printConsoleSection( 'RUN ASSEMBLY DETECTION' );
	
    % if( isdeployed )
        opts.zMax = Inf;
        FindAssemblies( RASTER_file , opts );
    % else
    %   FindAssemblies( RASTER_file );
    % end
    AssembliesActivations( strrep( RASTER_file , '_RASTER' , '_PROMAX-MP-ASSEMBLIES' ) );
    
    output_args = load( strrep( RASTER_file , '_RASTER' , '_PROMAX-MP-ASSEMBLIES' ) );
    
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
