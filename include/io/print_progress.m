function [ output_args ] = print_progress( p , type , timer )
%PRINT_PROGRESS( p , type , timer ) Prints an progress bar in the console.
%   While working within the console it might be desirable to monitor the
%   progress of certain calculation. However, the classic waitbar(  ) is
%   not accessible here, so that print_progress(  ) is a way to go.
%
%   INPUT:
%   p [scalar]: percentage of completion
%   type [string]: 'initialise', 'update' to update the value of an
%   initialised progress bar, and 'finalise'
%   timer [scalar, uint64]: timer variable a returned from TIC
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

S_Z = 80;

CHAR_SPACE = char( 32 );
if( ~isdeployed )
    %CHAR_BLOCK = char( 9608 );
	CHAR_BLOCK = char( 61 );
else
    CHAR_BLOCK = char( 61 );
end
CHAR_FRAME = char( 124 );

try
	if( nargin > 2 && ( p ~= 0 && p~= 1 ) )
		dT = ceil( ( (1 - p) / p ) * toc( timer ) );
		dTx = sprintf( ' ~%5s left' , print_timeinterval( dT ) );
	else
		dT = NaN;
	end
catch
	dT = NaN;
end

switch type
	case 'initialise'
        %fprintf( '\n' );
		fprintf( [ CHAR_FRAME repmat( CHAR_SPACE , 1 , (S_Z - 2) ) CHAR_FRAME ] );

	case 'update'
		fprintf( repmat( '\b' , 1 , S_Z ) );
		if( ~isnan( dT ) )
			fprintf( [ CHAR_FRAME repmat( CHAR_BLOCK , 1 , ceil( p * (S_Z - 2 - length( dTx )) ) ) repmat( CHAR_SPACE , 1 , floor( (1 - p) * (S_Z - 2 - length( dTx )) ) ) CHAR_FRAME dTx ] );
		else
			fprintf( [ CHAR_FRAME repmat( CHAR_BLOCK , 1 , ceil( p * (S_Z - 2) ) ) repmat( CHAR_SPACE , 1 , floor( (1 - p) * (S_Z - 2) ) ) CHAR_FRAME ] );
        end
		
		% S = [ char_frame repmat( char_block , 1 , ceil( p * (s_z - 2) ) ) repmat( char_space , 1 , floor( (1 - p) * (s_z - 2) ) ) char_frame ];
		% S_p = sprintf( '%5.1f%%' , 100 * p ); S( (s_z / 2 - 2):(s_z / 2 + 3) ) = S_p;
	case 'finalise'
		fprintf( repmat( '\b' , 1 , S_Z ) );
		
		fprintf( [ CHAR_FRAME repmat( CHAR_BLOCK , 1 , (S_Z - 2) ) CHAR_FRAME ] );
		fprintf( '\n' );
end

output_args = dT;

end

% function [ output_args ] = print_progress( p , type )
% %print_progress Prints an updatable progress bar to the console
% %   While working within the console it might be desirable to monitor the
% %   progress of certain calculation. However, the classic waitbar(  ) is
% %   not accessible here, so that print_progress(  ) is a way to go.
%
%
%
% s_z = 80;
%
% char_space = char( 32 );
% % char_block = char( 9608 );
% char_block = char( 61 );
% char_frame = char( 124 );
%
% S = '';
%
% switch type
% 	case 'initialise'
% 		fprintf( '\n' );
% 		fprintf( [ char_frame repmat( char_space , 1 , (s_z - 2) ) char_frame ] );
% 		fprintf( '\n' );
% 	case 'update'
% 		fprintf( repmat( '\b' , 1 , s_z + 1 ) );
% 		fprintf( [ char_frame repmat( char_block , 1 , ceil( p * (s_z - 2) ) ) repmat( char_space , 1 , floor( (1 - p) * (s_z - 2) ) ) char_frame ] );
% 		fprintf( '\n' );
%
% 		% S = [ char_frame repmat( char_block , 1 , ceil( p * (s_z - 2) ) ) repmat( char_space , 1 , floor( (1 - p) * (s_z - 2) ) ) char_frame ];
% 		% S_p = sprintf( '%5.1f%%' , 100 * p ); S( (s_z / 2 - 2):(s_z / 2 + 3) ) = S_p;
% 	case 'finalise'
% 		fprintf( repmat( '\b' , 1 , s_z + 1 ) );
%
% 		fprintf( [ char_frame repmat( char_block , 1 , (s_z - 2) ) char_frame ] );
% 		fprintf( '\n' );
% end
%
% end