function [ output_args ] = normalisePatternEnumeration( input_args )
%NORMALISEPATTERNENUMERATION( input_args ) Returns a enumeration of the
%input pattern Given the input pattern [ 2 4 3 1 1 3 4 2 ] this function
%turns is into [ 1 2 3 4 4 3 2 1 ] keeping the overall pattern unchanged
%but imposing a normalised enumeration.
%
%   EXAMPLE:
%   normalisePatternEnumeration( [ 2 4 3 1 1 3 4 2 ] )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

output_args = zeros( 1 , numel(input_args) );

G = unique( input_args , 'stable' );
for r=1:numel( G )
	output_args( input_args == G(r) ) = r;
end
end