function [ output_args ] = iif( input_args , true_output_args , false_output_args )
%IIF( input_args , true_output_args , false_output_args ) Inline
%if-then-else function to use in anonymous functions.
%
%
%   === Jan Moelter, The University of Queensland, 2016 ===================
%

if( input_args )
	output_args = true_output_args;
else
	output_args = false_output_args;
end
	
end

