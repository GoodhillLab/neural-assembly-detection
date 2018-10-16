function [ spike_probability , spike_probability_raster , spike_probability_raster_thresholds , oopsi_deconvolution ] = findDF_FSpikeProbability( dF_F , dT , t1_2 )
%FINDDF_FSPIKEPROBABILITY( dF_F , dT , t1_2 )
% 
% PARAMETERS:
% \_ dF_F [TxN matrix]: dF/F-signal for N units in T time steps
% \_ dT: signal temporal resolution in units of seconds
% \_ t1_2: calcium-indicator fluorescence half-life in units of seconds
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

dF_F = dF_F( ~any( isnan( dF_F ) , 2 ) , : );

%% DECONVOLVE DF/F DATA

V = struct( 'dt' , dT );
P = struct( 'gam' , 1 ./ 2^( dT / t1_2 ) ); % gam = F(t+dT)/F(t)

n_best = NaN * ones( size( dF_F ) );

for n = 1:size( dF_F , 2 )
    
    F = dF_F( : , n );
    [ n_best(:,n) , P_best(n) , ~ , ~ ] = fast_oopsi( F , V , P );
    
end

%%

oopsi_deconvolution.n_best = n_best;
oopsi_deconvolution.P_best = P_best;


CONST.STD_SIG_THRESHOLD = 3;
% \_ CONST.STD_THRESHOLD: spike probability standard deviation significance
% level

spike_probability = oopsi_deconvolution.n_best ./ max( oopsi_deconvolution.n_best );
spike_probability_raster = double( spike_probability > CONST.STD_SIG_THRESHOLD * std( spike_probability(:) ) );


CONST.SHUFFLE_ROUNDS = 1000;
% \_ CONST.SHUFFLE_ROUNDS: rounds of shuffling for coactivity null model
CONST.SIGNIFICANCE_P = [ 0.05 , 0.01 ];
% \_ CONST.SIGNIFICANCE_P: significance level for the spike probability
% coactivity

[ coactivity_thresholds , ~ ] = findSignificantCoactivity( spike_probability_raster , struct( 'shuffle_rounds' , CONST.SHUFFLE_ROUNDS , 'significance_p' , CONST.SIGNIFICANCE_P ) );

spike_probability_raster_thresholds = struct( 'p' , num2cell( CONST.SIGNIFICANCE_P ) , 'coactivity' , num2cell( coactivity_thresholds ) );

end