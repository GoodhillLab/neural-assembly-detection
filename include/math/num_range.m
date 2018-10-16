function [ output_args ] = num_range( X )
%NUM_RANGE( X ) Returns the numerical range of a collection of numbers X.
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

output_args = [ min( X(:) ) max( X(:) ) ];

end

