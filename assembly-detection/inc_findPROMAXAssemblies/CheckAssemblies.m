function CheckAssemblies( filenameCLUSTERS )
%CHECKASSEMBLIES( filenameCLUSTERS )
%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

if( exist( filenameCLUSTERS , 'file' ) == 2 )
    CLUSTERS_mat = load( filenameCLUSTERS );
    
    
    [ ~ , filenameCLUSTERS_name , ~ ] = fileparts( filenameCLUSTERS );
    
    hf = figure( 'Name' , 'zMax cut-off for including cells in assemblies' , ...
        'MenuBar' , 'none' , ...
        'Position' , get( 0 , 'ScreenSize' ) , ...
        'KeyPressFcn' , @KeyPressFcn );
    
    plot( CLUSTERS_mat.zMaxDensity.x , CLUSTERS_mat.zMaxDensity.densityNorm , 'LineWidth' , 2 , 'Color' , 'black' );
    hold on;
    plot( CLUSTERS_mat.zMaxDensity.normCutOff * [ 1 1 ] , get( gca , 'ylim' ) , 'LineWidth' , 2 , 'LineStyle' , '--' , 'Color' , 'red' );
    
    title([ 'zMax cut-off' ' : ' filenameCLUSTERS_name ],'FontWeight','Bold','Interpreter','none');
    xlabel('zMax'); ylabel('Density');
    
    try
        while( waitforbuttonpress ~= 1 )
            
        end
    catch
        
    end
end

    function KeyPressFcn(h, eventArgs)
        
        switch eventArgs.Key
            case 'delete'
                fprintf( 2 , 'DELETE *_CLUSTERS.mat :: %s \n\n' , filenameCLUSTERS );
        end
        
        close( h );
    end
end