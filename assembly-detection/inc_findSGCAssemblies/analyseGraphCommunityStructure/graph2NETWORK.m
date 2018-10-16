function [ output_args ] = graph2NETWORK( graph )
%GRAPH2NETWORK( graph ) Builds a NETWORK structure from a graph object.
%
%   INPUT:
%   graph [graph]: undirected, unweigted graph
%       
%   OUTPUT:
%   output_args [struct]: NETWORK structure
%
%   EXAMPLES:
%   analyseGraphCommunityStructure( ZacharyKarateClub , struct( 'Iterations' , 1 , 'MonteCarloSteps' , 10000 , 'initialK' , 3 ) )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%


if( isa( graph , 'graph' ) )
	
	NETWORK.nvertices = graph.numnodes;
	
	for v = 1:graph.numnodes
		NETWORK.vertex(v).id = v - 1;
		NETWORK.vertex(v).degree = graph.degree(v);
		NETWORK.vertex(v).label = '';
		
		n_ = graph.neighbors(v);
		for n = 1:numel( n_ )
			NETWORK.vertex(v).edge(n).target = n_(n) - 1;
			NETWORK.vertex(v).edge(n).weight = 1;
		end
	end
	
	output_args = NETWORK;
else
    error( 'Invalid input.' );
	output_args = NaN;
end

end

