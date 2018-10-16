function [ output_args ] = ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( output_directory , id , N_units , T_durationRange , dT_durationRange , assembly_configuration_list , i_assembly_configuration , calcium_T1_2Range ,  eventFreqRange , eventMultRange , noiseSTDRange , saturationKRange )
%ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( output_directory , id , N_units , T_durationRange , dT_durationRange , assembly_configuration_list , i_assembly_configuration , calcium_T1_2Range ,  eventFreqRange , eventMultRange , noiseSTDRange , saturationKRange )
% 
% PARAMETERS:
% \_ output_directory: output directory for the calcium fluorescence dataset
% \_ id: id (name) of the calcium fluorescence dataset
% \_ N_units: number of neuronal units to be simulated ( -- obsolete -- )
% \_ T_durationRange: duration of the simulation in units of seconds
% \_ dT_durationRange: temporal resolution (width of a time step) in units 
% of seconds
% \_ assembly_configuration_list: list of assembly configurations
% \_ i_assembly_configuration: assembly configuration index from list
% \_ calcium_T1_2Range: calcium-indicator fluorescence half-life in units of
% seconds
% \_ eventFreqRange: frequency at which a unit is particularly active in units
% of inverse seconds
% \_ eventMultRange: firing rate multiplier at active events
% \_ noiseSTDRange: standard deviation of the Gaussian noise on the fluorescence
% \_ saturationKRange: saturation constant
%
% Note: When given a range for any of the parameters "*Range", a value is
% selected uniformly from this range.
%
% EXAMPLE:
% ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( '~/Desktop/' , 'TEST_1' , 0 , 120 , 0.5 , 'HEX12_K10_medium' , 1 , 1 , 0.1 , 6 , 0 , Inf )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

if( exist( output_directory , 'dir' ) ~= 7 )
	output_directory = '~/';
end

fprintf( 1 , [ '\n' ] );

%% > PRINT FUNCTION-CALL
if( isdeployed )
    printConsoleSection( 'FUNCTION CALL' );
    
    fprintf( 1 , [ 'ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( %s , %s , %s , %s , %s , %s , %s , %s , %s , %s , %s , %s )' '\n' ] , output_directory , id , N_units , T_durationRange , dT_durationRange , assembly_configuration_list , i_assembly_configuration , calcium_T1_2Range , eventFreqRange , eventMultRange , noiseSTDRange , saturationKRange );
    fprintf( 1 , [ '\n' ] );
end

%% > INITIALISE RANDOM-NUMBER-GENERATOR
printConsoleSection( 'INITIALISE RANDOM-NUMBER-GENERATOR' );

seed_devrandom();

%% > SET PARAMETERS
printConsoleSection( 'SET PARAMETERS' );

if( isdeployed )
	N_units = str2double( N_units );
	T_durationRange = str2num( T_durationRange );
    dT_durationRange = str2num( dT_durationRange );
	i_assembly_configuration = str2double( i_assembly_configuration );
    calcium_T1_2Range = str2num( calcium_T1_2Range );
	eventFreqRange = str2num( eventFreqRange );
    eventMultRange = str2num( eventMultRange );
    noiseSTDRange = str2num( noiseSTDRange );
    saturationKRange = str2num( saturationKRange );
end

X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K0' ) = HEXv_K0();

%X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K10_small' ) = HEXv_K10_small();
%X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K10_medium' ) = HEXv_K10_medium();
%X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K10_large' ) = HEXv_K10_large();

X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K10_medium_N' ) = HEXv_K10_medium_N();
X_ASSEMBLY_CONFIGURATIONS.( 'HEXv_K5_medium_N' ) = HEXv_K5_medium_N();

%X_ASSEMBLY_CONFIGURATIONS.( 'HEX16_varK_small' ) = HEX16_varK_small();
%X_ASSEMBLY_CONFIGURATIONS.( 'HEX16_varK_medium' ) = HEX16_varK_medium();
%X_ASSEMBLY_CONFIGURATIONS.( 'HEX16_varK_large' ) = HEX16_varK_large();

X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_varK_medium_N' ) = HEX12_varK_medium_N();

X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_var' ) = HEX12_K10_var();

X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_small_overlap' ) = HEX12_K10_small_overlap();
X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_medium_overlap' ) = HEX12_K10_medium_overlap();
X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_large_overlap' ) = HEX12_K10_large_overlap();

X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_small' ) = HEX12_K10_small();
X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_medium' ) = HEX12_K10_medium();
X_ASSEMBLY_CONFIGURATIONS.( 'HEX12_K10_large' ) = HEX12_K10_large();

X_ASSEMBLY_CONFIGURATIONS.( 'HEX5_K5_medium' ) = HEX5_K5_medium();

X = X_ASSEMBLY_CONFIGURATIONS.( assembly_configuration_list );

assembly_configuration = X{i_assembly_configuration}.A;
topology = X{i_assembly_configuration}.T;

% > OVERRIDE ASSEMBLY CONFIGURATION
%v = 5;
%topology = hexagonal_tiling( v );
%assembly_configuration = cellfun( @uint16 , mat2cell( 1:( 3 * ( v + 1 ) * v + 1 ) , 1 , [ 1 , 6 * [ 1:v ] ] ) , 'UniformOutput' , false );
% \_ "hexagonal rings"-layout


uniform_transform = @( x , X ) ( max( X ) - min( X ) ) .* x + min( X );
% \_ uniform_transform( x , X ): maps a uniform random variable x on [0 1]
% to the range X, so that uniform_transform( x , X ) is uniformly
% distributed on X



N_units = numel( topology );

PARAMS.units = N_units;
%PARAMS.dT_step = dT_duration;
PARAMS.dT_step = round( iif( numel( dT_durationRange ) == 1 , dT_durationRange , uniform_transform( rand() , num_range(dT_durationRange) ) ) , 3 , 'decimals' );
%PARAMS.time_steps = T_duration / PARAMS.dT_step;
PARAMS.time_steps = ceil( iif( numel( T_durationRange ) == 1 , T_durationRange , uniform_transform( rand() , num_range(T_durationRange) ) ) / PARAMS.dT_step );
fprintf( 1 , [ '> %u neuronal units over a time of %.1f s and %u time steps' '\n' ] , PARAMS.units , PARAMS.time_steps * PARAMS.dT_step , PARAMS.time_steps );

%if( any( ismember( 1:numel( assembly_configurations ) , i_assembly_configuration ) ) )
	PARAMS.assembly_configuration = assembly_configuration;
	PARAMS.assembly_configuration = cellfun( @(a) a( a <= PARAMS.units ) , PARAMS.assembly_configuration , 'UniformOutput' , false );
%else
%	PARAMS.assembly_configuration = {};
%end

% > OVERRIDE ASSEMBLY CONFIGURATION
%PARAMS.assembly_configuration = transpose( { uint16( [1,2,3,4,5,6,13,14,15,16,17,18,25,26,27,28,29,30,37,38,39,40,41,42,49,50,51,52,53,54,61,62,63,64,65,66] ) ; uint16( [7,8,9,10,11,12,19,20,21,22,23,24,31,32,33,34,35,36,43,44,45,46,47,48,55,56,57,58,59,60,67,68,69,70,71,72] ) ; uint16( [79,80,81,82,83,84,91,92,93,94,95,96,103,104,105,106,107,108,115,116,117,118,119,120,127,128,129,130,131,132,139,140,141,142,143,144] ) ; uint16( [73,74,75,76,77,78,85,86,87,88,89,90,97,98,99,100,101,102,109,110,111,112,113,114,121,122,123,124,125,126,133,134,135,136,137,138] ) } );
% \_ "4-square"-layout
%

PARAMS.rate_range = [ 1 6 ];
fprintf( 1 , [ '> neuronal firing rate between %.1f and %.1f Hz (s^-1)' '\n' ] , PARAMS.rate_range );
PARAMS.eventDuration = 0.5;
fprintf( 1 , [ '> neuronal firing events of length %.0f ms' '\n' ] , 1000 * PARAMS.eventDuration );
%PARAMS.eventFreq = eventFreq;
PARAMS.eventFreq = iif( numel( eventFreqRange ) == 1 , eventFreqRange , uniform_transform( rand() , num_range(eventFreqRange) ) );
fprintf( 1 , [ '> neuronal firing events at a frequency of %.1f mHz (1e-3 s^-1)' '\n' ] , 1000 * PARAMS.eventFreq );
PARAMS.eventMult = iif( numel( eventMultRange ) == 1 , eventMultRange , uniform_transform( rand() , num_range(eventMultRange) ) );
fprintf( 1 , [ '> neuronal firing rate elevation factor of %.1f at events' '\n' ] , PARAMS.eventMult );

% PARAMS.calcium_T1_2 = 1;
% \_ GCaMP6s half-life: 1s (cf. Chen et al. 2013 Nature 499)
PARAMS.calcium_T1_2 = iif( numel( calcium_T1_2Range ) == 1 , calcium_T1_2Range , uniform_transform( rand() , num_range(calcium_T1_2Range) ) );
fprintf( 1 , [ '> calcium indicator decay half-life of %.1f s' '\n' ] , PARAMS.calcium_T1_2 );
PARAMS.saturation_K = iif( numel( saturationKRange ) == 1 , saturationKRange , uniform_transform( rand() , num_range(saturationKRange) ) );
fprintf( 1 , [ '> calcium indicator fluorescence saturation constant of %.1f' '\n' ] , PARAMS.saturation_K );

PARAMS.noiseSTD = iif( numel( noiseSTDRange ) == 1 , noiseSTDRange , uniform_transform( rand() , num_range(noiseSTDRange) ) );
fprintf( 1 , [ '> fluorescence noise standard deviation of %.3f' '\n' ] , PARAMS.noiseSTD );

fprintf( 1 , [ '\n' ] );

%PARAMS
%return;

%% > CREATE TOPOLOGY
% printConsoleSection( 'CREATE TOPOLOGY' );
% 
% a = 12;
% topology = arrayfun( @(n) [ fix( ( n - 1 ) / a ) , mod( n - 1 , a ) ] , 1:PARAMS.units , 'UniformOutput' , false );
% clearvars a;

%% > INITIALISE RANDOM-NUMBER-GENERATOR
printConsoleSection( 'RE-INITIALISE RANDOM-NUMBER-GENERATOR' );

seed_devrandom();
%rng( 0 , 'twister' );

%% > GENERATE CALCIUM-FLUORESCENCE (dF/F)
printConsoleSection( 'GENERATE CALCIUM-FLUORESCENCE (dF/F)' );

[ dF_F , F , F0 ] = generateArtificialCalciumFluorescence( PARAMS.units , PARAMS.time_steps , PARAMS.dT_step , PARAMS.assembly_configuration , PARAMS.calcium_T1_2 , PARAMS.rate_range , PARAMS.eventDuration , PARAMS.eventFreq , PARAMS.eventMult , PARAMS.noiseSTD , PARAMS.saturation_K );

%% > SAVE OUTPUT
printConsoleSection( 'SAVE OUTPUT' );

output_args.calcium_fluorescence.F = F;
output_args.calcium_fluorescence.F0 = F0;
output_args.calcium_fluorescence.dF_F = dF_F;

output_args.topology = topology;

output_args.parameter = PARAMS;


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