function [ output_args ] = cross_evaluation( f , X , Y )
%CROSS_EVALUATION( f , X , Y ) Returns the matrix f(x,y) for x in X and y
%in Y.
%
%   INPUT:
%   f [function handle]: two-argument function
%   X [1x? cell]: data points
%   Y [1x? cell]: data points, =X if not explicitly given
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk(2,3);
if( nargin == 2 )
	Y = X;
end

output_args = NaN * ones( numel( X ) , numel( Y ) );

for ix = 1:numel( X )
	for iy = 1:numel( Y )
		output_args( ix , iy ) = f( X{ix} , Y{iy} );
	end
end

end