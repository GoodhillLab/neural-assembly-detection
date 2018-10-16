function [ output_args ] = findICAAssemblies( deltaFoF , KS_significance )
%FINDICAASSEMBLIES( deltaFoF , KS_significance )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

narginchk(1,2);
if( nargin == 1 )
    KS_significance = 0.1;
end

if( size( deltaFoF , 1 ) >= size( deltaFoF , 2 ) )
    
    X = transpose( deltaFoF );
    
    
    opts.threshold.method = 'MarcenkoPastur';
    opts.Patterns.method = 'ICA';
    opts.Patterns.number_of_iterations = 500;
    
    ica_assembly_patterns = assembly_patterns( X , opts );
    
    mp_assembly_vectors = cellfun( @(a) largest_positive( a ) , num2cell( ica_assembly_patterns , 1 ) , 'UniformOutput' , false );
    
    
    opts.threshold.method = 'circularshift';
    opts.threshold.permutations_percentile = 95;
    opts.threshold.number_of_permutations = 500;
    opts.Patterns.method = 'ICA';
    opts.Patterns.number_of_iterations = 500;
    
    ica_assembly_patterns = assembly_patterns( X , opts );
    
    cs_assembly_vectors = cellfun( @(a) largest_positive( a ) , num2cell( ica_assembly_patterns , 1 ) , 'UniformOutput' , false );
    
    
    
    for i = 1:numel( KS_significance )
        
        output_args(i).cs_assembly_vectors = cs_assembly_vectors;
        
        output_args(i).cs_assemblies = transpose( cellfun( @(v) find( abs(v) > mean(abs(v)) + 2 * std(abs(v)) ) , output_args(i).cs_assembly_vectors , 'UniformOutput' , false ) );
        output_args(i).ca_assemblies = output_args(i).cs_assemblies( ~cellfun( @isempty , output_args(i).cs_assemblies , 'UniformOutput' , true ) );
        
        
        
        output_args(i).ks_alpha = KS_significance(i);
        
        output_args(i).mp_assembly_vectors = mp_assembly_vectors;
        output_args(i).mp_assembly_vectors = output_args(i).mp_assembly_vectors( cellfun( @(x) kstest( zscore( x ) , 'Alpha' , output_args(i).ks_alpha ) , output_args(i).mp_assembly_vectors , 'UniformOutput' , true ) );
        % \_ select only those assembly vectors whose components seem to not come from a standard normal distribution
        
        output_args(i).mp_assemblies = transpose( cellfun( @(v) find( abs(v) > mean(abs(v)) + 2 * std(abs(v)) ) , output_args(i).mp_assembly_vectors , 'UniformOutput' , false ) );
        output_args(i).mp_assemblies = output_args(i).mp_assemblies( ~cellfun( @isempty , output_args(i).mp_assemblies , 'UniformOutput' , true ) );
        
        
    end
    
else
    
    error( [ 'Error :: N > T' ] );
end

end
