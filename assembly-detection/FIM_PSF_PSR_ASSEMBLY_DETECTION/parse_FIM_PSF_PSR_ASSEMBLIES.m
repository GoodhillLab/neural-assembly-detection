function [ output_args ] = parse_FIM_PSF_PSR_ASSEMBLIES( input_args )

output_args = cell(0,0);

for a = input_args
    R_ = regexp( a{:} , '([\d\s]+) \[supp=\d+\]' , 'tokens' );
    
    if( ~isempty( R_ ) )
        output_args{ numel( output_args ) + 1 } = sort( cellfun( @str2double , strsplit( char( R_{1} ) ) , 'UniformOutput' , true ) );
    end
end

end

