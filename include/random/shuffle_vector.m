function [ output_args i_shuffle ] = shuffle_vector( input_args )
%shuffle Shuffles the elements of a vector

i_shuffle = randperm( numel( input_args ) );
output_args = input_args( i_shuffle );

end