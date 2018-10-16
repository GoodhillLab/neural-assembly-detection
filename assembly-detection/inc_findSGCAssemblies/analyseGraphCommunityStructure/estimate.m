function output_args = estimate( graph , opts )
%ESTIMATE( graph , opts ) Program to calculate the number of communities in
%   a network using the method of Newman and Reinert, which calculates a
%   posterior probability by Monte Carlo simulation of the integrated
%   likelihood of a degree-corrected stochastic block model.
%
%	This function implements the approach described in M. E. J. Newman and
%	G. Reinert. "Estimating the number of communities in a network". Phys.
%	Rev. Lett. 117 (2016).
%   Apart from slight modifications with regard to the I/O this is a 1:1
%   translation of the original programm 'estimate' written in C code and
%   published by Mark Newman on 6. April 2016.
%
%   To use this function refer to the wrapper functions.
%



%/* Program to calculate the number of communities in a network using the
% * method of Newman and Reinert, which calculates a posterior probability
% * by Monte Carlo simulation of the integrated likelihood of a
% * degree-corrected stochastic block model
% *
% * Written by Mark Newman  6 APR 2016
% */

%/* Function control /*

narginchk(2,2);

if( ~isa( graph , 'graph' ) || isequal( sort( fieldnames( opts ) ) , sort( { 'K' , 'K0' , 'seed' , 'MCsweeps' , 'verbose' } ) ) )
	error( 'Invalid input.' );
end

output_args = struct( 'k' , num2cell( NaN * ones( 1 , opts.MCsweeps ) ) , 'g' , NaN , 'E' , NaN );

%/* Program control */

VERBOSE = opts.verbose;

%/* Constants */

K = opts.K;																	% Maximum number of groups
K0 = opts.K0;															    %* Initial number of groups
MCSWEEPS = opts.MCsweeps;													% Number of Monte Carlo sweeps
SAMPLE = 10;																% Interval at which to print out results, in sweeps

%/* Globals */

G = NaN;																	% Struct storing the network
twom = 0;																	% Twice the number of edges
p = 0;																		% Average edge probability

k = 0;																		% Current value of k
g = NaN;																	% Group assignments
n = NaN;																	% Group sizes
m = NaN;																	% Edge counts

lnfact = NaN;																% Look-up table of log-gamma-values
E = 0;																		% Log probability

%/* main() */

if( ~isnan( opts.seed ) && isnumeric( opts.seed ) )
	
	rng(opts.seed,'twister')

else
	
	%// Initialize the random number generator from the system clock
	
	rng('shuffle','twister')
end

%// Read the network from stdin

if( VERBOSE == 2 )
	fprintf( 2 , 'Reading network...\n' );
end

G = graph2NETWORK( graph );
twom = 0;
for u_ = 0:( G.nvertices - 1 )
	twom = twom + G.vertex(1+(u_)).degree;
end
p = twom / ( G.nvertices * G.nvertices );

if( VERBOSE == 2 )
	fprintf( 2 , 'Read network with %i nodes and %i edges\n' , G.nvertices , twom/2 );
end

%// Make the lookup table

maketable()

%// Initialize the group assignment

initgroups()

%// Perform the Monte Carlo

if( VERBOSE == 1 )
	MCTIMER = tic;
	print_progress( 0 , 'initialise' );
end

for s_ = 0:( MCSWEEPS - 1 )
	if( VERBOSE == 2 )
		fprintf( 2 , 'Sweep %i...\r' , s_ );
	end
	sweep();
	
	output_args(1+(s_)).k = k;
	output_args(1+(s_)).g = g;
	output_args(1+(s_)).E = E;
	if( mod( s_ , SAMPLE ) == 0 )
		switch( VERBOSE )
			case 1
				print_progress( ( s_ + 1 ) / MCSWEEPS , 'update' , MCTIMER );
			case 2
				fprintf( 1 , [ 'Sweep %i: k = %i , E = %g' , '\n' ] , s_ , k , E );
		end
	end
end

if( VERBOSE == 1 )
	print_progress( 1 , 'finalise' );
end

if( VERBOSE == 2 )
	fprintf( 2 , '\n' );
end


%% Make a lookup table of log-factorial values

	function maketable()
		% t = 0;
		% length = 0;
		
		length = twom + G.nvertices + 1;
		lnfact = zeros( 1 , length );
		for t = 0:( length - 1 )
			lnfact(1+(t)) = gammaln( t + 1 );
		end
	end

%% Log-probability function

	function output_args = logp( n , m )
		% r = 0; s = 0;
		% kappa = 0;
		res = 0;
		
		for r = 0:( k - 1 )
			res = res + lnfact(1+(n(1+(r))));
			
			if( n(1+(r)) > 0 )
				kappa = 0;
				for s = 0:( k - 1 )
					kappa = kappa + m(1+(r),1+(s));
				end
				res = res + ( kappa * log( n(1+(r)) ) + lnfact(1+(n(1+(r)) - 1)) - lnfact(1+(kappa + n(1+(r)) - 1)) );
				res = res + ( lnfact(1+(m(1+(r),1+(r)) / 2)) - ( ( m(1+(r),1+(r)) / 2 ) + 1 ) * log( 0.5 * p * n(1+(r)) * n(1+(r)) + 1 ) );
				
				for s = (r+1):(k - 1)
					res = res + ( lnfact(1+(m(1+(r),1+(s)))) - ( m(1+(r),1+(s)) + 1 ) * log( p * n(1+(r)) * n(1+(s)) + 1 ) );
				end
			end
		end
		
		output_args = res;
	end

%% Initial group assignment

	function initgroups()
		% i = 0; u = 0; v = 0;
		% r = 0;
		
		%// Make the initial group assignments at random
		
		g = zeros(1,G.nvertices);
		for u = 0:( G.nvertices - 1 )
			%* g(1+(u)) = randi( K ) - 1;
			g(1+(u)) = randi( K0 ) - 1;
		end
		
		%// Calculate the values of the n's
		
		n = zeros(1,K);
		for u = 0:( G.nvertices - 1 )
			n(1+(g(1+(u)))) = n(1+(g(1+(u)))) + 1;
		end
		
		%// Calcalate the values of the m's
		
		m = zeros(K,K);
		for u = 0:( G.nvertices - 1 )
			for i = 0:( G.vertex(1+(u)).degree - 1 )
				v = G.vertex(1+(u)).edge(1+(i)).target;
				m(1+(g(1+(u))),1+(g(1+(v)))) = m(1+(g(1+(u))),1+(g(1+(v)))) + 1;
			end
		end
		
		%// Initialize k and the log-probability
		
		%* k = K;
		k = K0;
		E = logp(n,m);
		
	end

%% Function to update value of k

	function changek()
		% r = 0; s = 0; u = 0;
		% kp = 0;
		empty = 0;
		% map = zeros(1,K);
		% sum = 0;
		
		%// With probability 0.5, decrease k, otherwise increase it
		
		if( rand() < 0.5 )
			
			%// Count the number of empty groups
			
			for r = 0:( k - 1 )
				if( n(1+(r)) == 0 )
					empty = empty + 1;
				end
			end
			
			%// If there are any empty groups, remove one of them, or otherwise do nothing
			
			if( empty > 0 )
				
				%// If there is more than one empty group, choose at random which one to remove
				
				bool_ = true;
				while( bool_ )
					r = randi( k ) - 1;
					bool_ = ( n(1+(r)) > 0 );
				end
				
				%DEBUG: fprintf( 1, 'changek(): X__ = %lu\n' , X__ );
				
				%// Decrease k by 1
				
				k = k - 1;
				
				%// Update the group labels
				
				for u = 0:( G.nvertices - 1 )
					if( g(1+(u)) == k )
						g(1+(u)) = r;
					end
				end
				
				%// Update n_r
				
				n(1+(r)) = n(1+(k));
				
				%// Update m_rs
				
				for s = 0:( k - 1 )
					if( r == s )
						m(1+(r),1+(r)) = m(1+(k),1+(k));
					else
						m(1+(r),1+(s)) = m(1+(k),1+(s));
						m(1+(s),1+(r)) = m(1+(s),1+(k));
					end
				end
			end
		else
			%// With probability k/(n+k) increase k by 1, adding an empty group
			
			if((G.nvertices + k) * rand() < k)
				if( k < K )
					n(1+(k)) = 0;
					for r = 0:k
						m(1+(k),1+(r)) = 0;
						m(1+(r),1+(k)) = 0;
					end
					k = k + 1;
				end
			end
		end
		
	end

%% Function to update n and m for a proposed move

	function nmupdate( r , s , d )
		% t = 0;
		
		n(1+(r)) = n(1+(r)) - 1;
		n(1+(s)) = n(1+(s)) + 1;
		
		for t = 0:( k - 1 )
			m(1+(r),1+(t)) = m(1+(r),1+(t)) - d(1+(t));
			m(1+(t),1+(r)) = m(1+(t),1+(r)) - d(1+(t));
			m(1+(s),1+(t)) = m(1+(s),1+(t)) + d(1+(t));
			m(1+(t),1+(s)) = m(1+(t),1+(s)) + d(1+(t));
		end
	end

%% Function that does one MCMC sweep (i.e., n individual moves) using the heatbath algorithm

	function output_args = sweep()
		% i  = 0; j = 0; u = 0; v = 0;
		% r = 0; s = 0;
		% temp = 0;
		accept = 0;
		d = zeros(1,K);
		% x = 0; Z = 0; sum = 0;
		newE = zeros(1,K);
		boltzmann = zeros(1,K);
		
		for i = 0:( G.nvertices - 1 )
			
			%// Optionally, perform a k-changing move
			
			if((G.nvertices + 1) * rand() < 1)
				changek();
			end
			
			
			%// Choose a random node
			
			u = randi( G.nvertices ) - 1;
			r = g(1+(u));
			
			%// Find the number of edges this node has to each group
			
			for s = 0:( k - 1 )
				d(1+(s)) = 0;
			end
			
			for j = 0:( G.vertex(1+(u)).degree - 1 )
				v = G.vertex(1+(u)).edge(1+(j)).target;
				d(1+(g(1+(v)))) = d(1+(g(1+(v)))) + 1;
			end
			
			
			%// Calculate the probabilities of moving it to each group in turn
						
			Z = 0;
			for s = 0:( k - 1 )
				if(s == r)
					newE(1+(s)) = E;
				else
					nmupdate(r,s,d);
					newE(1+(s)) = logp(n,m);
					nmupdate(s,r,d);
				end
				boltzmann(1+(s)) = exp(newE(1+(s)) - E);
				Z = Z + boltzmann(1+(s));
			end
			
			%// Choose which move to make based on these probabilities
			
			x = Z * rand();
			sum = 0;
			for s = 0:( k - 1 )
				sum = sum + boltzmann(1+(s));
				if(sum > x)
					break;
				end
			end
			
			%// Make the move
			
			if( s ~= r )
				g(1+(u)) = s;
				nmupdate(r,s,d);
				E = newE(1+(s));
				accept = accept + 1;
			end
		end
		
		output_args = accept / G.nvertices;
	end

end