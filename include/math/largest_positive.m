function [ output_args ] = largest_positive( input_args )
%LARGEST_POSITIVE( input_args )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

[ ~ , iM ] = max( abs( input_args ) );
output_args = input_args / sign( input_args( iM ) );

end

