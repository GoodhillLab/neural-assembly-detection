function [ output_args ] = ICA_ASSEMBLY_DETECTION( CALCIUM_FLUORESCENCE_file )
%ICA_ASSEMBLY_DETECTION( CALCIUM_FLUORESCENCE_file )
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
    
    fprintf( 1 , [ 'ICA_ASSEMBLY_DETECTION( %s )' '\n' ] , CALCIUM_FLUORESCENCE_file );
    fprintf( 1 , [ '\n' ] );
end

if( exist( CALCIUM_FLUORESCENCE_file , 'file' ) == 2 )
		
	CALCIUM_FLUORESCENCE_mat = load( CALCIUM_FLUORESCENCE_file );
		
	printConsoleSection( 'RUN ICA ASSEMBLY DETECTION' );
	
	output_args = findICAAssemblies( CALCIUM_FLUORESCENCE_mat.calcium_fluorescence.dF_F , 1e-10 );
		
	printConsoleSection( 'SAVE RESULTS' );
	
	[ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
	
	OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_ICA-ASSEMBLIES' ) '.mat' ];
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
