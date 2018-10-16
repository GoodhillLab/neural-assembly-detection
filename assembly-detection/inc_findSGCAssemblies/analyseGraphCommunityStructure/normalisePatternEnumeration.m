function [ output_args ] = normalisePatternEnumeration( input_args )
%NORMALISEPATTERNENUMERATION( input_args ) Normalised the enumeration of
%the input pattern while keeping the overall pattern unchanged. In the
%enumeration new indices will be added as required.
%
%   INPUT:
%   input_args [1x? matrix]: input pattern
%
%   OUTPUT:
%   output_args [1x? matrix]: normalised enumeration of the input pattern
%
%   EXAMPLE:
%   normalisePatternEnumeration( [ 2 5 3 8 8 3 5 2 ] )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

output_args = zeros( 1 , numel(input_args) );

G = unique( input_args , 'stable' );
for r=1:numel( G )
	output_args( input_args == G(r) ) = r;
end
end