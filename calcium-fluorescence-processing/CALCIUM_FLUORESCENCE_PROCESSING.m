function [ output_args ] = CALCIUM_FLUORESCENCE_PROCESSING( CALCIUM_FLUORESCENCE_file , varargin )
%CALCIUM_FLUORESCENCE_PROCESSING( CALCIUM_FLUORESCENCE_file , varargin )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

narginchk(1,Inf);

fprintf( 1 , [ '\n' ] );

%% > PRINT FUNCTION-CALL
if( isdeployed )
    printConsoleSection( 'FUNCTION CALL' );
    
    fprintf( 1 , [ 'CALCIUM_FLUORESCENCE_PROCESSING( %s )' '\n' ] , CALCIUM_FLUORESCENCE_file );
    fprintf( 1 , [ '\n' ] );
end

if( exist( [ CALCIUM_FLUORESCENCE_file ] , 'file' ) == 2 )
    
    printConsoleSection( 'PROCESS CALCIUM FLUORESCENCE' );
    
    CALCIUM_FLUORESCENCE_mat = load( [ CALCIUM_FLUORESCENCE_file ] );
    
    
    PRESETS = varargin;
    if( numel( PRESETS ) == 0 )
        PRESETS = { 'ALL' };
    end
    Q_presets = @( S ) any( strcmp( PRESETS , S ) );
    
    
    %% > MAKE *_ACTIVITY-RASTER.MAT ( => similarity-graph-clustering )
    if( Q_presets( 'ALL' ) || Q_presets( 'ACTIVITY-RASTER' ) || Q_presets( 'ACTIVITY-FIM-RASTER' ) || Q_presets( 'ACTIVITY-ISING-FREQUENCIES' ) )
        
        fprintf( 1 , [ 'Prepare *_ACTIVITY-RASTER.MAT file for similarity-graph-clustering ...' '\n' ] );
        
        [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
        OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_ACTIVITY-RASTER' ) '.mat' ];
        
        if( exist( OUTPUT_PATH , 'file' ) ~= 2 )
            tic;
            [ sig_dF_F_activity , sig_dF_F_coactivity_threshold , sig_dF_F_coactivity_peaks ] = findSignificantDF_FCoactivity( CALCIUM_FLUORESCENCE_mat.calcium_fluorescence.dF_F );
            
            output_args.activity_raster = sig_dF_F_activity;
            output_args.activity_raster_threshold = sig_dF_F_coactivity_threshold;
            output_args.activity_raster_peaks = sig_dF_F_coactivity_peaks;
            
            
            save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
            fileattrib( OUTPUT_PATH , '+w' , 'g' );
            
            toc
        else
            output_args = load( OUTPUT_PATH );
            sig_dF_F_activity = output_args.activity_raster;
            
            fprintf( 1 , [ '> ...' '\n' ] );
        end
        
        fprintf( 1 , [ '' '\n' ] );
    end
    
    %% > MAKE *_ACTIVITY-FIM-RASTER.DAT ( => frequent-item-set-mining ("fim+psf+psr" / "ccn+psf+psr") )
    if( Q_presets( 'ALL' ) || Q_presets( 'ACTIVITY-FIM-RASTER' ) )
        
        fprintf( 1 , [ 'Prepare *_ACTIVITY-FIM-RASTER.DAT file for frequent-item-set-mining ...' '\n' ] );
        
        [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
        OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_ACTIVITY-FIM-RASTER' ) '.dat' ];
        
        if( exist( OUTPUT_PATH , 'file' ) ~= 2 )
            tic;
            
            %------------------------------------------------------------------
            
            output_args = cellfun( @(t) find( t == 1 ) , num2cell( sig_dF_F_activity , 2 ) , 'UniformOutput' , false );
            
            i_ = fopen( OUTPUT_PATH , 'w' );
            
            for k = 1:numel( output_args )
                
                for n = output_args{k}
                    fprintf( i_ , '%u ' , n );
                end
                fprintf( i_ , '\n' );
            end
            
            fclose( i_ );
            
            %------------------------------------------------------------------
            
            %     i_ = fopen( '' , 'w' );
            %
            %     for t = 1:size( sig_dF_F_activity , 1 )
            %
            %         for n = 1:size( sig_dF_F_activity , 2 )
            %             if( sig_dF_F_activity(t,n) == 1 )
            %                 fprintf( i_ , '%u %.3f\n' , n , ( t - 0.5 ) * CALCIUM_FLUORESCENCE_mat.parameter.dT_step );
            %             end
            %         end
            %     end
            %
            %     fclose( i_ );
            
            %------------------------------------------------------------------
            
            %     output_args = cellfun( @(s) ( find( s == 1 ) - 0.5 ) * CALCIUM_FLUORESCENCE_mat.parameter.dT_step , num2cell( sig_dF_F_activity , 1 ) , 'UniformOutput' , false );
            %
            %     i_ = fopen( '' , 'w' );
            %
            %     for n = 1:numel( output_args )
            %
            %         fprintf( i_ , '%u' , n );
            %
            %         for t = output_args{n}
            %             fprintf( i_ , ' %.3f' , t );
            %         end
            %         fprintf( i_ , '\n' );
            %     end
            %
            %     fclose( i_ );
            
            %------------------------------------------------------------------
            
            fileattrib( OUTPUT_PATH , '+w' , 'g' );
            
            toc
        else
            fprintf( 1 , [ '> ...' '\n' ] );
        end
        
        fprintf( 1 , [ '' '\n' ] );
    end
    
    %% > MAKE *_ACTIVITY-ISING-FREQUENCIES.p ( => ACE )
    if( Q_presets( 'ALL' ) || Q_presets( 'ACTIVITY-ISING-FREQUENCIES' ) )
        
        %fprintf( 1 , [ 'Prepare *_ACTIVITY-ISING-FREQUENCIES.p file for ACE ...' '\n' ] );
        %
        % [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
        % OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_ACTIVITY-ISING-FREQUENCIES' ) '.p' ];
        %
        % if( exist( OUTPUT_PATH , 'file' ) ~= 2 )
        %     tic;
        %
        %     i_ = fopen( OUTPUT_PATH , 'w' );
        %     print_p( i_ , sig_dF_F_activity );
        %     fclose( i_ );
        %
        %     fileattrib( OUTPUT_PATH , '+w' , 'g' );
        %
        %     toc
        % else
        %     fprintf( 1 , [ '> ...' '\n' ] );
        % end
        %
        % fprintf( 1 , [ '' '\n' ] );
    end
    
    %% > MAKE *_SPIKE-PROBABILITY-RASTER.MAT ( => CORE algorithm )
    if( Q_presets( 'ALL' ) || Q_presets( 'SPIKE-PROBABILITY-RASTER' ) )
        
        fprintf( 1 , [ 'Prepare *_SPIKE-PROBABILITY-RASTER.MAT file ...' '\n' ] );
        
        [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
        OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_SPIKE-PROBABILITY-RASTER' ) '.mat' ];
        
        if( exist( OUTPUT_PATH , 'file' ) ~= 2 )
            tic;
            [ ~ , spike_probability_raster , spike_probability_raster_thresholds , oopsi_deconvolution ] = findDF_FSpikeProbability( CALCIUM_FLUORESCENCE_mat.calcium_fluorescence.dF_F , CALCIUM_FLUORESCENCE_mat.parameter.dT_step , CALCIUM_FLUORESCENCE_mat.parameter.calcium_T1_2 );
            
            output_args = [];
            output_args.spike_probability_raster = spike_probability_raster;
            output_args.spike_probability_raster_thresholds = spike_probability_raster_thresholds;
            output_args.oopsi_deconvolution = oopsi_deconvolution;
            
            
            save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
            fileattrib( OUTPUT_PATH , '+w' , 'g' );
            
            toc
        end
        
        fprintf( 1 , [ '' '\n' ] );
    end
    
    %% > MAKE *_RASTER.MAT ( => PCA-promax )
    if( Q_presets( 'ALL' ) || Q_presets( 'RASTER' ) )
        
        fprintf( 1 , [ 'Prepare *_RASTER.MAT file for PCA-promax ...' '\n' ] );
        
        [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
        OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_RASTER' ) '.mat' ];
        
        if( exist( OUTPUT_PATH , 'file' ) ~= 2 )
            tic;
            [ ~ , output_args ] = findSignificantFluorescenceTraces( CALCIUM_FLUORESCENCE_mat.calcium_fluorescence.dF_F , CALCIUM_FLUORESCENCE_mat.parameter.calcium_T1_2 / log(2) , 1 / CALCIUM_FLUORESCENCE_mat.parameter.dT_step );
            
            save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
            fileattrib( OUTPUT_PATH , '+w' , 'g' );
            
            toc
        else
            fprintf( 1 , [ '> ...' '\n' ] );
        end
        
        fprintf( 1 , [ '' '\n' ] );
    end
    
    %% >
    
    output_args = NaN;
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
else
    
    output_args = NaN;
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
end

end

