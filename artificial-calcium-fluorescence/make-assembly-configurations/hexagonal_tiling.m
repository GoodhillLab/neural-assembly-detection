function [ output_args ] = hexagonal_tiling( v )
%HEXAGONAL_TILING( v ) Returns a hexagonal tiling of degree v
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

%z = @( N ) ceil( 0.5 * ( sqrt(4 * N - 1) / sqrt(3) - 1 ) );

narginchk(1,1);

rot = @( a ) [ cos(a) , -sin(a) ; sin(a) , cos(a) ];

w = [ 0 0 ];
output_args = { w };

for n = 1:v
	w = [ 0 n ];
	u = - [ sqrt(3) 1 ] / 2;
	
	for e = 1:6
		for e_ = 1:n
			output_args{ numel( output_args ) + 1 } = w;
			w = w + u;
		end
		
		u = u * transpose( rot( pi / 3 ) );
	end
end

output_args = transpose( output_args );

end

