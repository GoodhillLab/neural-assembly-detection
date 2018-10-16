function printConsoleSection( input_args )
%PRINTCONSOLESECTION( input_args )
%   
%   INPUT:
%   input_args [string]: section title
%
%   EXAMPLE:
%   printConsoleSection( 'Hello World!' )
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

S_Z = 80;

fprintf( 1 , [ repmat( '_' , 1 , S_Z ) '\n' ] );
fprintf( 1 , [ ':: %s' '\n' ] , upper( input_args ) );
fprintf( 1 , [ '\n' ] );

end

