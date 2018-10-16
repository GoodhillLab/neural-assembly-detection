function [ output_args ] = meanActivityPattern( activityPatterns , activityThreshold )
%MEANACTIVITYPATTERN ( activityPatterns , activityThreshold )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

%% AVERAGE ACTIVITY PATTERNS
output_args = mean( cell2mat( activityPatterns ) , 1 );

%% THRESHOLD THE AVERAGE PATTERN
output_args = output_args .* ( output_args > activityThreshold );

end

