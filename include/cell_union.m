function [ output_args ] = cell_union( input_args , mode )
%CELL_UNION( input_args , mode ) Returns the union of all sets (vectors) in
%the a cell array.
%
%   INPUT:
%   input_args [1x? cell]: cell array of sets (vectors)
%   mode [string]: union mode ('','sorted','stable')
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk(1,2);
if( nargin < 2 )
	mode = '';
end

output_args = [];
input_args = input_args(:);

if( any( strcmp( mode , { 'sorted' , 'stable' } ) ) )
	
	for j = 1:numel( input_args );
		output_args = union( output_args , input_args{j} , mode );
	end
	
else
	
	for j = 1:numel( input_args );
		output_args = union( output_args , input_args{j} );
	end
	
end

end

