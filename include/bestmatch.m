function [ output_args ] = bestmatch( d , C1 , C2 )
%BESTMATCH( d , C1 , C2 ) Returns the BestMatch index between two
%clusterings C1 and C2 for given set distance d.
%
%   INPUT:
%   d [function handle]: two-argument distance function
%   C1 [1x? cell]: clustering
%   C2 [1x? cell]: clustering
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

narginchk(3,3)

if( min( numel( C1 ) , numel( C2 ) ) > 0 )
    output_args = sum( min( cross_evaluation( d , C1 , C2 ) , [] , 2 ) ) + sum( min( cross_evaluation( d , C2 , C1 ) , [] , 2 ) );
else
    output_args = NaN;
end

end

