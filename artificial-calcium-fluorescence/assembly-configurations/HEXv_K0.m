%% 400 EXAMPLES OF ASSEMBLY CONFIGURATIONS WITH 0 ASSEMBLIES IN A HONEYCOMB STRUCTURED TECTUM
% THERE ARE 40 CONFIGURATIONS WHICH ARE EMBEDDED IN TECTA OF INCREASING
% DEGREE v = 8 , ... 17
%
% THE ASSEMBLY CONFIGURATION IS LEFT EMPTY AS NULL-CONTROL

%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

function [ X ] = HEXv_K0()

for t = 0:9
    for j = 1:40
    
    % THE UNDERLYING TOPOLOGY
    T = hexagonal_tiling( 8 + t );
    
    % THE SET OF ASSEMBLY-CONFIGURATION
    X{ 40 * t + j } = struct( 'T' , { T } , 'A' , { {  } } );

    end
end

end