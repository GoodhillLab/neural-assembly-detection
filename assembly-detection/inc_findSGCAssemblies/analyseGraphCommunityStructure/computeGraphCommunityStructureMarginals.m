function [ k_ , k_distibution , g_ ] = computeGraphCommunityStructureMarginals( estimate_output )
%COMPUTEGRAPHCOMMUNITYSTRUCTUREMARGINALS( estimate_output ) Computes the
%marginal distributions to estimate community structure of a graph given
%the results of (several rounds) of Markov-Chain-Monte-Carlo sampling to
%from the function ESTIMATEGRAPHCOMMUNITYSTRUCTURE.
%
%   INPUT:
%   estimate_output [1x? cell]: estimate-MCMC samples from
%   ESTIMATEGRAPHCOMMUNITYSTRUCTURE.
%       
%   OUTPUT:
%   k_ [scalar]: most likely number of communities
%   k_distibution [?x2 matrix]: probability distribution for the number of
%   communities
%   g_ [1x? matrix]: proposed community structure given the most likely
%   number of communities 
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

K = []; G = [];

for i = 1:numel( estimate_output )
	
	estimate_output_E = [ estimate_output{i}.E ];
	EQ_sample = estimate_output_E( ceil( numel( estimate_output_E ) / 2 ):end );
	
	i_EQ = estimate_output_E > mean( EQ_sample ) - 2 * max( abs( EQ_sample - mean( EQ_sample ) ) );
	i_EQ( 1:find( ~i_EQ , 1 , 'last' ) ) = false;
	
	K_ = [ estimate_output{i}.k ];
	K = [ K , K_( i_EQ ) ];
	G_ = cell2mat( transpose( { estimate_output{i}.g } ) );
	G = [ G ; G_( i_EQ , : ) ];
end

%

H = double( min( unique(K) ):max( unique(K) ) );
k_distibution = transpose( [ H ; histc( K , H ) / length( K ) ] );

[ ~ , j ] = max( k_distibution( : , 2 ) );
k_ = k_distibution( j , 1 );
k_  = uint8( k_ );

%

N = size( G , 2 );

g_distribution = zeros( N , k_ );
g_ = ones( 1 , N );

iK = transpose( K == k_ );
for n=1:N
	for r=1:k_
		g_distribution( n , r ) = sum( iK & ( G( : , n ) == r ) );
	end
end
g_distribution = g_distribution / sum( iK );

for n=1:N
	[ ~ , g_(n) ] = max( g_distribution( n , : ) );
end
g_ = uint8( g_ );

end

