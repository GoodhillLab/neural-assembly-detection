function [ output_args ] = print_timeinterval( dT )
%PRINT_TIMEINTERVAL( dT ) Prints time-interval in optimal units.
%
%   INPUT:
%   dT [scalar]: time interval in seconds
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%


dTx = timevec( dT );
switch( find( dTx , 1 ) )
	case 1
		output_args = sprintf( '%.1fd' , dot( dTx , [ 1 , 1/( 24 ) , 1/( 24 * 60 ) , 1/( 24 * 60 * 60 ) ] ) );
	case 2
		output_args = sprintf( '%.1fh' , dot( dTx , [ 0 , 1 , 1/( 60 ) , 1/( 60 * 60 ) ] ) );
	case 3
		output_args = sprintf( '%.1fm' , dot( dTx , [ 0 , 0 , 1 , 1/( 60 ) ] ) );
	case 4
		output_args = sprintf( '%.1fs' , dot( dTx , [ 0 , 0 , 0 , 1 ] ) );
end

end

function [ output_args ] = timevec( t )

mult = [ 24 60 60 1 ];
output_args = zeros( 1 , numel( mult ) );

for j = 1:numel( mult )
	output_args( j ) = fix( t / prod( mult(j:end) ) );
	t = rem( t , prod( mult(j:end) ) );
end
end