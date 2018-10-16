function [ dF_F , F , F0 ] = generateArtificialCalciumFluorescence( units , time_steps , dT_step , assembly_configuration , calcium_T1_2 , rate_range , eventDuration_t , eventFreq_f , eventMult , noiseSTD , saturation_K )
%GENERATEARTIFICIALCALCIUMFLUORESCENCE( units , time_steps , dT_step , assembly_configuration , calcium_T1_2 , rate_range , eventDuration_t , eventFreq_f , eventMult , noiseSTD , saturation_K )
%
% PARAMETERS:
% \_ units: number of neuronal units to be simulated
% \_ time_steps: number of time steps
% \_ dT_step: width of a time step in units of seconds
% \_ assembly_configuration [1 x ? cell array]: list of collections of
% units to be combined to assemblies
% \_ calcium_T1_2: calcium-indicator fluorescence half-life in units of
% seconds
% \_ rateRange: range of base firing rate in units of inverse seconds
% (Hertz)
% \_ eventDuration_t: duration of active events in units of seconds
% \_ eventFreq_f: frequency at which a unit is particularly active in units
% of inverse seconds
% \_ eventMult: firing rate multiplier at active events
% \_ noiseSTD: standard deviation of the Gaussian noise on the fluorescence
% \_ saturation_K: saturation constant
%
% EXAMPLE:
% [ dF_F , F , F0 ] = generateArtificialCalciumFluorescence( 40 , 10 * 60 * 2 , 0.5 , transpose( num2cell( transpose( reshape( 1:40 , 10 , 4 ) ) , 2 ) ) , 1 , [ 1 6 ] , 0.5 , 0.01 , 6 , 0 , Inf )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%


N = units;
T = time_steps;

dT = dT_step;

dt = 0.001;

T_offset = ceil( 2 * calcium_T1_2 / dT_step );
% \_ T_offset: number of time steps as a initial offset

if( mod( dT , dt ) ~= 0 )
	error( 'mod( dT , dt ) ~= 0' );
end
dT_n = round( dT / dt );

spikecount_field = generateSpikeCountField( N , ( T + T_offset ) , dT , assembly_configuration , rate_range , max( 1 , eventDuration_t / dT ) , eventFreq_f * dT , eventMult );
% \_ spikecount_field [T+T_offset x N matrix]:

calcium_activity = zeros( T , N );
% \_ calcium_activity [T x N matrix]:

calcium_convolution_kernel = calcium_kernel( calcium_T1_2 , dt );
% \_ calcium_convolution_kernel [? x 1 matrix]:

spike_train = zeros( ( T + T_offset ) * dT_n , 1 );
%calcium_convolved_spike_train = zeros( T * dT_n + numel( calcium_convolution_kernel ) - 1 , 1 );

print_progress( 0 , 'initialise' );

for n = 1:N
	spike_train = 0 * spike_train;
	%calcium_convolved_spike_train = 0 * calcium_convolved_spike_train;
	
	i_spikes = cell_union( arrayfun( @( t ) dT_n * ( t - 1 ) + randi( [ 1 , dT_n ] , 1 , spikecount_field( t , n ) ) , transpose( 1:( T + T_offset ) ) , 'UniformOutput' , false ) );
	spike_train( i_spikes ) = 1;
	
	calcium_convolved_spike_train = conv( spike_train , calcium_convolution_kernel );
	
	calcium_activity( : , n ) = calcium_convolved_spike_train( dT_n * [ ( T_offset + 1 ):( T + T_offset ) ] );
    if( saturation_K < Inf )
        calcium_activity( : , n ) = arrayfun( @(c) saturation_K * c / ( c + saturation_K ) , calcium_activity( : , n ) , 'UniformOutput' , true );
    end
	
	% >> plot calcium signal
	
	if( ~isdeployed && false )
		
		ca_signal = calcium_convolved_spike_train( ( T_offset * dT_n + 1 ):( ( T + T_offset ) * dT_n ) );
		
		subplot( 3 , 1 , [ 1:2 ] );
		plot( 1:(T * dT_n) , ca_signal , 'Color' , HTML2RGB( '5100C0' ) );
		hold on;
		plot( dT_n * [ 1:T ] , calcium_activity( : , n ) );
		hold off;
		xlim( [ 1 (T * dT_n) ] );
		ylim( [ 0 1.1*max( ca_signal ) ] );
		
		set( gca , 'XTick' , [ 0:( 10^floor( log10( T * dT ) ) ):( T * dT ) ] / dt , 'XTickLabel' , arrayfun( @(t) sprintf( '%u s' , t ) , [ 0:( 10^floor( log10( T * dT ) ) ):( T * dT ) ] , 'UniformOutput' , false ) );
		set( gca , 'YTick' , [] );
		
		subplot( 3 , 1 , 3 );
		bar( 1:(T * dT_n) , spike_train( ( T_offset * dT_n + 1 ):( ( T + T_offset ) * dT_n ) )' , 'k' );
		hold off;
		xlim( [ 1 (T * dT_n) ] );
		
		set( gca , 'XTick' , [] , 'YTick' , [] );
		
	end
	
    print_progress( n / N , 'update' );
end

print_progress( 1 , 'finalise' );

clearvars spike_train calcium_convolution_kernel calcium_convolved_spike_train;

if( noiseSTD > 0 )
    fprintf( 1 , [ 'Add Gaussian Noise ...' '\n' ] );
    calcium_activity = calcium_activity + random( 'Normal' , 0 , noiseSTD * ones( size( calcium_activity ) ) );
    calcium_activity = calcium_activity .* ( calcium_activity > 0 );
end

calcium_fluorescence.rawF = transpose( calcium_activity );
calcium_fluorescence = fitF0smoother( calcium_fluorescence , ceil( 15 / dT ) );

dF_F = transpose( calcium_fluorescence.Fnorm );
F = transpose( calcium_fluorescence.rawF );
F0 = transpose( calcium_fluorescence.F0 );

end

function [ spikecount_field ] = generateSpikeCountField( N , T , dT , assemblies , rateRange , eventDur , eventProb , eventMult )
% \_ N: number of neuronal units to be simulated
% \_ T: number of time steps
% \_ dT: width of a time step in units of seconds
% \_ assemblies [1 x ? cell array]: list of collections of units to be
% combined to assemblies
% \_ rateRange: range of base firing rate in units of inverse seconds
% (Hertz)
% \_ eventDur: length of an active event as a number of timesteps
% \_ eventProb: probability with which a unit is particularly active in a
% single timestep
% \_ eventMult: firing rate multiplier at active events

uniform_transform = @( x , X ) ( max( X ) - min( X ) ) .* x + min( X );
% \_ uniform_transform( x , X ): maps a uniform random variable x on [0 1]
% to the range X, so that uniform_transform( x , X ) is uniformly
% distributed on X

activation_field = false( [ T , N ] );
% \_ activation_field [T x N matrix]: field of activation event indicators

for a = assemblies
	activation_field( : , a{:} ) = activation_field( : , a{:} ) | repmat( rand( T , 1 ) < eventProb , 1 , numel( a{:} ) );
end
a = { setdiff( 1:N , cell_union( assemblies ) ) };
activation_field( : , a{:} ) = activation_field( : , a{:} ) | ( rand( T , numel( a{:} ) ) < eventProb );

if( eventDur > 1 )
    activation_field_mask = activation_field;
    frac_activation_field_mask = activation_field_mask & ( random( 'Binomial' , 1 , frac( eventDur ) * ones( size(activation_field_mask) ) ) == 1 );

    for m = 1:(floor(eventDur) - 1)
        %activation_field = activation_field | circshift( activation_field , m , 1 );
        activation_field = activation_field | padarray( activation_field_mask(1:(end - m),:) , [ m 0 ] , false , 'pre' );
    end
    m = floor(eventDur);
    activation_field = activation_field | padarray( frac_activation_field_mask(1:(end - m),:) , [ m 0 ] , false , 'pre' );
end

firingrate_field = repmat( uniform_transform( rand( 1 , N ) , rateRange ) , T , 1 );
%firingrate_field = repmat( randi( rateRange , 1 , N ) , T , 1 );
% \_ firingrate_field [T x N matrix]: field of firing rates

firingrate_field( activation_field ) = eventMult * firingrate_field( activation_field );

spikecount_field = random( 'Poisson' , firingrate_field * dT );
% \_ spikecount_field [T x N matrix]: field of spike counts at every time
% step

end

function [ output ] = calcium_kernel( T1_2 , dt )
% \_ T1_2: kernel half-life time in units of seconds
% \_ dt: time-precision in units of seconds

a = 1;
k = @( t ) a * exp( - log( 2 ) * t / T1_2 );

cut_off_ratio = 0.01;

output = k( transpose( 0:dt:ceil( - log2( cut_off_ratio * a ) * T1_2 ) ) );
end