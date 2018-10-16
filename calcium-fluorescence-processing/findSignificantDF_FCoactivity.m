function [ sig_dF_F_activity , sig_dF_F_coactivity_threshold , sig_dF_F_coactivity_peaks ] = findSignificantDF_FCoactivity( dF_F )
%FINDSIGNIFICANTDF_FCOACTIVITY( dF_F )
%
% PARAMETERS:
% \_ dF_F [TxN matrix]: dF/F-signal for N units in T time steps
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

dF_F = dF_F( ~any( isnan( dF_F ) , 2 ) , : );

%% PREPROCESS THE dF/F-signal

CONST.STD_SIG_THRESHOLD = 2;
% \_ CONST.STD_SIG_THRESHOLD: dF/F-signal significance level in standard
% deviation from the mean

fprintf( 1 , [ 'significance threshold: ' num2str( CONST.STD_SIG_THRESHOLD ) 'STD' '\n' ] );

[ T , N ] = size( dF_F );

mean_dF_F = mean( dF_F , 1 );
% \_ mean_dF_F [1 x N matrix]: mean dF/F-signal for N units
std_dF_F = std( dF_F , 0 , 1 );
% \_ std_dF_F [1 x N matrix]: standard deviation in dF/F-signal for N units


sig_dF_F_activity = double( dF_F > repmat( mean_dF_F + CONST.STD_SIG_THRESHOLD * std_dF_F , T , 1 ) );
% \_ sig_dF_F_mask [T x N matrix]: binary mask of significant dF/F-signal for N units in T time steps

clearvars CONST;

%% FIND SIGNIFICANT PEAKS IN THE THE COACTIVITY

CONST.SHUFFLE_ROUNDS = 1000;
% \_ CONST.SHUFFLE_ROUNDS: rounds of shuffling for coactivity null model
CONST.SIGNIFICANCE_P = 0.05;
% \_ CONST.SIGNIFICANCE_P: significance level for the dF/F-coactivity

[ sig_dF_F_coactivity_threshold , ~ ] = findSignificantCoactivity( sig_dF_F_activity , struct( 'shuffle_rounds' , CONST.SHUFFLE_ROUNDS , 'significance_p' , CONST.SIGNIFICANCE_P ) );
% \_ sig_dF_F_coactivity_threshold: significance threshold for the
% dF/F-coactivity

normalised_sig_dF_F_coactivity = sum( sig_dF_F_activity , 2 ) ./ max( sum( sig_dF_F_activity , 2 ) );
normalised_sig_dF_F_coactivity_threshold = sig_dF_F_coactivity_threshold / max( sum( sig_dF_F_activity , 2 ) );
% \_ normalised_sig_dF_F_coactivity [T x 1 matrix]: normalised dF/F-coactivity
% \_ normalised_sig_dF_F_coactivity_threshold: normalised significance
% threshold for the normalised dF/F-coactivity

[ sig_dF_F_coactivity_peaks , ~ ] = peakfinder( normalised_sig_dF_F_coactivity , 0.05 , normalised_sig_dF_F_coactivity_threshold , 1 , true , false );
% \_ sig_dF_F_coactivity_peaks [? x 1 matrix]: peak times of the
% dF/F-coactivity

clearvars CONST;

%% END

end