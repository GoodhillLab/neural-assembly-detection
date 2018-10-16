
clc;

ROOT = input( 'ROOT = ' , 's' );

items = dir( [ ROOT ] );
items = transpose( items );
items = items( [ items.isdir ] & [ ~strcmp( { items.name } , '.' ) ] & [ ~strcmp( { items.name } , '..' ) ] );

items = items( shuffle_vector( 1:numel( items ) ) );


for I = items
    
    if( exist( [ ROOT '/' I.name '/' I.name '_RASTER.mat' ] , 'file' ) == 2 )
       
        if( exist( [ ROOT '/' I.name '/' I.name '_CLUSTERS.mat' ] , 'file' ) ~= 2 )
            
            PROMAX_ASSEMBLY_DETECTION( [ ROOT '/' I.name '/' I.name '_RASTER.mat' ] );
            
        end
    end
end