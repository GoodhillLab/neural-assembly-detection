function [ output_args ] = bestmatch_expectation( N , numelA , numelB , nA_dist , nB_dist )
%BESTMATCH_EXPECTATION( N , numelA , numelB , nA_dist , nB_dist )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

% N = 20;
% numelA = 2; numelB = 3;
% 
% mA = 10; wA = 6;
% mB = 15; wB = 4;
% 
% nA_dist = [ (mA-wA):(mA+wA) ; arrayfun( @(k) binopdf( k , 2 * wA , 0.5 ) , [ (mA-wA):(mA+wA) ] - ( mA - wA ) , 'UniformOutput' , true ) ]';
% nB_dist = [ (mB-wB):(mB+wB) ; arrayfun( @(k) binopdf( k , 2 * wB , 0.5 ) , [ (mB-wB):(mB+wB) ] - ( mB - wB ) , 'UniformOutput' , true ) ]';

X = [];
for nA = nA_dist(:,1)'
    for nB = nB_dist(:,1)'
        for m = 0:min(nA,nB)
            X = [ X , 1 - m / ( nA + nB - m ) ];
        end
    end
end
X = unique( X );

F_X = F( X );

pA = arrayfun( @(x) sum( F_X( X >= x ) )^(numelA) - sum( F_X( X > x ) )^(numelA) , X , 'UniformOutput' , true );
pB = arrayfun( @(x) sum( F_X( X >= x ) )^(numelB) - sum( F_X( X > x ) )^(numelB) , X , 'UniformOutput' , true );

output_args = 1 - ( numelA * sum( X .* pB ) + numelB * sum( X .* pA ) ) / ( numelA + numelB );


    function f = F( r )
        
        f = 0 * r;
        
%         for nA_j = 1:size( nA_dist , 1 )
%             for nB_j = 1:size( nB_dist , 1 )
%                 for i = 1:numel(r)
%                     
%                     x = ( nA_dist(nA_j,1) + nB_dist(nB_j,1) ) * ( 1 - 1/( 2-r(i) ) );
%                     if( abs( x - round( x ) ) < 1e-14 )
%                         x = round( x );
%                     end
%                     
%                     f(i) = f(i) + nA_dist(nA_j,2) * nB_dist(nB_j,2) * hygepdf( x , N , nA_dist(nA_j,1) , nB_dist(nB_j,1) );
%                     
%                 end
%             end
%         end
        
        
        nA_X = repmat( nA_dist(:,1) , 1 , size( nB_dist , 1 ) );
        nB_X = transpose( repmat( nB_dist(:,1) , 1 , size( nA_dist , 1 ) ) );
        
        for i = 1:numel(r)
            
            x = ( nA_X + nB_X ) * ( 1 - 1/( 2-r(i) ) );
            
            I = abs( x - round( x ) ) < 1e-14;
            x( I ) = round( x( I ) );
            
            H_X = hygepdf( x , N , nA_X , nB_X );
            
            
            f(i) = transpose( nA_dist(:,2) ) * H_X * nB_dist(:,2);
        end
        
    end

%function y = hypergeompdf( X , M , K , N )
%    y = ( gamma( 1+K )*gamma( 1-K+M )*gamma( 1+M-N )*gamma( 1+N ) )/( gamma( 1+M )*gamma( 1+K-X )*gamma( 1+N-X )*gamma( 1+X )*gamma( 1-K+M-N+X ) );
%end
end

