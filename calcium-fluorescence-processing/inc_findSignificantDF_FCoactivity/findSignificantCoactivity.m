function [ sig_coactivity , shuff_coactivity ] = findSignificantCoactivity( X , opts )
%FINDSIGNIFICANTCOACTIVITY( X , opts )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

[ T , ~ ] = size( X );

shuffle = @( X , d ) cell2mat( cellfun( @(x) x( reshape( randperm( numel( x ) ) , size( x ) ) ) , num2cell( X , d ) , 'UniformOutput' , false ) );
% \_ shuffle( X , d ): shuffle X along its d-th dimension, i.e. every slice
% of X along its d-th dimension is shuffled independently
% in particular, all( sum( shuffle( X , d ) , d ) == sum( X , d ) ) holds
% true

shuff_coactivity = zeros( opts.shuffle_rounds , T );
% \_ shuff_coactivity [opts.shuffle_rounds x T matrix]:

for s = 1:opts.shuffle_rounds
	shuff_coactivity( s , : ) = sum( shuffle( X , 1 ) , 2 );
end

sig_coactivity = prctile( shuff_coactivity(:) , ( 1 - opts.significance_p ) * 100 );
% \_ sig_coactivity: significant coactivity threshold estimated as the
% (1-opts.significance_p)-percentile from shuffled coactiviy levels

end