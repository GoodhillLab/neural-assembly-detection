function [ output_args ] = ASSEMBLIES_COLLECTION( CALCIUM_FLUORESCENCE_file )
%ASSEMBLIES_COLLECTION( CALCIUM_FLUORESCENCE_file )
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

narginchk(1,1);

fprintf( 1 , [ '\n' ] );

timerVal = tic;

%% > PRINT FUNCTION-CALL
if( isdeployed )
    printConsoleSection( 'FUNCTION CALL' );
    
    fprintf( 1 , [ 'ASSEMBLIES_COLLECTION( %s )' '\n' ] , CALCIUM_FLUORESCENCE_file );
    fprintf( 1 , [ '\n' ] );
end

if( exist( CALCIUM_FLUORESCENCE_file , 'file' ) == 2 )
    
    CALCIUM_FLUORESCENCE_mat = load( CALCIUM_FLUORESCENCE_file );
    
    if( false )
        
        % printConsoleSection( 'UPDATE PARAMETERS' );
        %
        % if( ~isfield( CALCIUM_FLUORESCENCE_mat.parameter , 'eventDuration' ) )
        %     CALCIUM_FLUORESCENCE_mat.parameter.eventDuration = 0.5;
        % end
        %
        % CALCIUM_FLUORESCENCE_mat.parameter = orderfields( CALCIUM_FLUORESCENCE_mat.parameter , { 'units' , 'dT_step' , 'time_steps' , 'assembly_configuration' , 'rate_range' , 'eventDuration' , 'eventFreq' , 'eventMult' , 'calcium_T1_2' } );
        %
        % save( CALCIUM_FLUORESCENCE_file , '-v7' , '-struct' , 'CALCIUM_FLUORESCENCE_mat' );
        % fileattrib( CALCIUM_FLUORESCENCE_file , '+w' , 'g' );
        
    end
    
    printConsoleSection( 'ASSEMBLIES COLLECTION' );
    
    output_args.parameter = CALCIUM_FLUORESCENCE_mat.parameter;
    if( isfield( CALCIUM_FLUORESCENCE_mat , 'meta_information' ) )
        output_args.meta_information = CALCIUM_FLUORESCENCE_mat.meta_information;
    end
    output_args.topology = CALCIUM_FLUORESCENCE_mat.topology;
    
    for SUFFIX = { '_ICA-ASSEMBLIES' , '_PROMAX-MP-ASSEMBLIES' , '_PROMAX-CS-ASSEMBLIES' , '_CORE-ASSEMBLIES' , '_SVD-ASSEMBLIES' , '_SGC-ASSEMBLIES' }
        
        clearvars 'SUFFIX_mat';
        
        if( exist( strrep( CALCIUM_FLUORESCENCE_file , '_CALCIUM-FLUORESCENCE' , SUFFIX{:} ) , 'file' ) == 2 )
            SUFFIX_mat = load( strrep( CALCIUM_FLUORESCENCE_file , '_CALCIUM-FLUORESCENCE' , SUFFIX{:} ) );
        end
        
        switch SUFFIX{:}
            case '_SGC-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> SGC assemblies' '\n' ] );
                    output_args.SGC_assemblies = transpose( SUFFIX_mat.assemblies );
                else
                    output_args.SGC_assemblies = NaN;
                end
                
            case '_PROMAX-MP-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> Promax-MP assemblies' '\n' ] );
                    output_args.PROMAX_MP_assemblies = SUFFIX_mat.assembliesCells;
                else
                    output_args.PROMAX_MP_assemblies = NaN;
                end
                
            case '_PROMAX-CS-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> Promax-CS assemblies' '\n' ] );
                    output_args.PROMAX_CS_assemblies = SUFFIX_mat.assembliesCells;
                else
                    output_args.PROMAX_CS_assemblies = NaN;
                end
                
            case '_ICA-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> ICA-CS & ICA-MP assemblies' '\n' ] );
                    output_args.ICA_CS_assemblies = transpose( cellfun( @transpose , SUFFIX_mat.cs_assemblies , 'UniformOutput' , false ) );
                    output_args.ICA_MP_assemblies = transpose( cellfun( @transpose , SUFFIX_mat.mp_assemblies , 'UniformOutput' , false ) );
                else
                    output_args.ICA_CS_assemblies = NaN;
                    output_args.ICA_MP_assemblies = NaN;
                end
                
            case '_CORE-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> CORE assemblies' '\n' ] );
                    output_args.CORE_assemblies = SUFFIX_mat.assemblies;
                else
                    output_args.CORE_assemblies = NaN;
                end
                
            case '_SVD-ASSEMBLIES'
                if( exist( 'SUFFIX_mat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> SVD assemblies' '\n' ] );
                    output_args.SVD_assemblies = SUFFIX_mat.assemblies;
                else
                    output_args.SVD_assemblies = NaN;
                end
        end
    end
    
    for SUFFIX = { '_FIM-PSF-PSR-ASSEMBLIES' }
        
        clearvars 'SUFFIX_dat';
        
        if( exist( strrep( CALCIUM_FLUORESCENCE_file , '_CALCIUM-FLUORESCENCE.mat' , [ SUFFIX{:} '.dat' ] ) , 'file' ) == 2 )
            SUFFIX_dat = read( strrep( CALCIUM_FLUORESCENCE_file , '_CALCIUM-FLUORESCENCE.mat' , [ SUFFIX{:} '.dat' ] ) );
        end
        
        
        switch SUFFIX{:}
            case '_FIM-PSF-PSR-ASSEMBLIES'
                if( exist( 'SUFFIX_dat' , 'var' ) == 1 )
                    fprintf( 1 , [ '> FIM+PSF+PSR assemblies' '\n' ] );
                    output_args.FIM_PSF_PSR_assemblies = parse_FIM_PSF_PSR_ASSEMBLIES( SUFFIX_dat );
                else
                    output_args.FIM_PSF_PSR_assemblies = NaN;
                end
                
        end
    end
    
    
    printConsoleSection( 'SAVE RESULTS' );
    
    [ directory , name , ~ ] = fileparts( CALCIUM_FLUORESCENCE_file );
    
    OUTPUT_PATH = [ directory '/' strrep( name , '_CALCIUM-FLUORESCENCE' , '_ASSEMBLIES-COLLECTION' ) '.mat' ];
    save( OUTPUT_PATH , '-v7' , '-struct' , 'output_args' );
    fileattrib( OUTPUT_PATH , '+w' , 'g' );
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
else
    output_args = NaN;
    
    fprintf( 1 , [ '>> END PROGRAM' '\n' ] );
    fprintf( 2 , [ '>> END PROGRAM' '\n' ] );
end

%% > PRINT TIMING
if( isdeployed )
    printConsoleSection( 'TIMING' );
    
    fprintf( 1 , [ 'Elapsed time (walltime): %.3fs\n' ] , toc(timerVal) );
    
end

end
