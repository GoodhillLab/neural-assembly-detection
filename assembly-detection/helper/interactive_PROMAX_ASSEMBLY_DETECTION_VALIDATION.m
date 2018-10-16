function interactive_PROMAX_ASSEMBLY_DETECTION_VALIDATION()

clc;

ROOT = input( 'ROOT = ' , 's' );

items = dir( [ ROOT ] );
items = transpose( items );
items = items( [ items.isdir ] & [ ~strcmp( { items.name } , '.' ) ] & [ ~strcmp( { items.name } , '..' ) ] );

items = items( shuffle_vector( 1:numel( items ) ) );

for I = items
    
    if( exist( [ ROOT '/' I.name '/' I.name '_CLUSTERS.mat' ] , 'file' ) == 2 )

        CheckAssemblies( [ ROOT '/' I.name '/' I.name '_CLUSTERS.mat' ] )
        
    end
end

end