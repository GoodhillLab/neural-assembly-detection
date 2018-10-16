function [ output_args ] = read( filename )
%READ( filename ) Reads a text file and returns a cell array of the lines.
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

% Alternative implementation:
% 
%     i_ = fopen( filename , 'r' );
%     while( ~boolean( feof(i_) ) )
%         output_args{ numel( output_args ) + 1 } = fgetl( i_ );
%     end
%     fclose(i_);

if( exist( filename , 'file' ) == 2 )
    i_ = fopen( filename , 'r' );
    
    output_args = textscan( i_ , '%s' , 'Delimiter' , '\n' );
    output_args = transpose( output_args{1} );
    
    fclose( i_ );
    
else
    
    output_args = {};
end

end

