function [ output_args ] = CALCIUM_FLUORESCENCE_CONVERSION( output_directory , id , dF_F_field , dT_duration , calcium_T1_2 )
%CALCIUM_FLUORESCENCE_CONVERSION( output_directory , id , dF_F_field , dT_duration , calcium_T1_2 )
% Usage: CALCIUM_FLUORESCENCE_CONVERSION( '~/' , 'TEST_1' , dF_F , 0.5 , 1 )

if( exist( output_directory , 'dir' ) ~= 7 )
	output_directory = '~/';
end

fprintf( 1 , [ '\n' ] );

%% > PRINT FUNCTION-CALL
if( isdeployed )
    printConsoleSection( 'FUNCTION CALL' );
    
    fprintf( 1 , [ 'CALCIUM_FLUORESCENCE_CONVERSION( %s , %s , %s , %s , %s )' '\n' ] , output_directory , id , NaN , dT_duration , calcium_T1_2 );
    fprintf( 1 , [ '\n' ] );
end

%% > SET PARAMETERS
printConsoleSection( 'SET PARAMETERS' );

N_units = size( dF_F_field , 2 );

topology = transpose( arrayfun( @(n) NaN , 1:N_units , 'UniformOutput' , false ) );

PARAMS.units = N_units;
PARAMS.dT_step = dT_duration;
PARAMS.time_steps = size( dF_F_field , 1 );
fprintf( 1 , [ '> %u neuronal units over a time of %.1f s and %u time steps' '\n' ] , PARAMS.units , PARAMS.time_steps * PARAMS.dT_step , PARAMS.time_steps );

PARAMS.assembly_configuration = NaN;

PARAMS.rate_range = NaN;
PARAMS.eventDuration = NaN;
PARAMS.eventFreq = NaN;
PARAMS.eventMult = NaN;


% PARAMS.calcium_T1_2 = 1;
% \_ GCaMP6s half-life: 1s (cf. Chen et al. 2013 Nature 499)
PARAMS.calcium_T1_2 = calcium_T1_2;
fprintf( 1 , [ '> calcium indicator dF/F half-life of %.1f s' '\n' ] , PARAMS.calcium_T1_2 );

PARAMS.saturation_K = NaN;
PARAMS.noiseSTD = NaN;

fprintf( 1 , [ '\n' ] );

%PARAMS
%return;

%% > SAVE OUTPUT
printConsoleSection( 'SAVE OUTPUT' );

output_args.calcium_fluorescence.F = NaN;
output_args.calcium_fluorescence.F0 = NaN;
output_args.calcium_fluorescence.dF_F = dF_F_field;

output_args.topology = topology;

output_args.parameter = PARAMS;

output_args.meta_information = [];


if( exist( [ output_directory '/' id ] , 'dir' ) ~= 7 )
	mkdir( [ output_directory '/' id ] );
end
fileattrib( [ output_directory '/' id ] , '+w' , 'g' );

OUTPUT_PATH = [ output_directory id '/' id '_CALCIUM-FLUORESCENCE' '.mat' ];
save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
fileattrib( OUTPUT_PATH , '+w' , 'g' );

fprintf( 1 , [ 'Calcium fluorescence saved to %s.' '\n' ] , OUTPUT_PATH );

%% > END

fprintf( 1 , [ '\n' '\n' ] );

beep on; beep;

fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
fprintf( 2 , [ '>> END PROGRAM' '\n' ] );

end