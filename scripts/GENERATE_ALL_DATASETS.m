%GENERATE_ALL_DATASETS
%
% Note: This script will generate 4800 datasets of surrogate calcium
% fluorescence activity, which were analysed in the corresponding paper.
% On a single desktop computer this may take several days or rather weeks
% and will require about 350GB of disk space.
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

OUTPUT_DIRECTORY = '~/Desktop/';

DEFAULT_PARAMETERS = struct( ...
    'T_durationRange' , 3600 , ...
    'dT_durationRange' , 0.5 , ...
    'assembly_configuration_list' , 'HEX12_K10_medium' , ...
    'calcium_T1_2Range' , 1 , ...
    'eventFreqRange' , 0.01 , ...
    'eventMultRange' , 6 , ...
    'noiseSTDRange' , 0 , ...
    'saturationKRange' , Inf ...
    );



for SERIES = { 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEXv_K10_medium_N__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_varK_medium_N__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_var__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_medium_overlap__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_medium__T0-7200s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_medium__T3600s_dT100-500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_medium__T3600s_dT500ms_cT0-2s_sKInf_eF10.0mHz_eM6_nS0' , 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF0.0-10.0mHz_eM6_nS0' , 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM1-26_nS0' , 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0-8' , 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sK0-1000_eF10.0mHz_eM6_nS0' }
    
    PARAMETERS = DEFAULT_PARAMETERS;
    
    switch( SERIES{:} )
        
        case 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            
        case 'HEXv_K10_medium_N__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'assembly_configuration_list' ) = 'HEXv_K10_medium_N';
            
        case 'HEX12_varK_medium_N__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'assembly_configuration_list' ) = 'HEX12_varK_medium_N';
            
        case 'HEX12_K10_var__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'assembly_configuration_list' ) = 'HEX12_K10_var';
            
        case 'HEX12_K10_medium_overlap__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'assembly_configuration_list' ) = 'HEX12_K10_medium_overlap';
            
        case 'HEX12_K10_medium__T0-7200s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'T_durationRange' ) = [0 7200];
            
        case 'HEX12_K10_medium__T3600s_dT100-500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'dT_durationRange' ) = [0.1 0.5];
            
        case 'HEX12_K10_medium__T3600s_dT500ms_cT0-2s_sKInf_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'calcium_T1_2Range' ) = [0 2];
            
        case 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF0.0-10.0mHz_eM6_nS0'
            PARAMETERS.( 'eventFreqRange' ) = [0 0.01];
            
        case 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM1-26_nS0'
            PARAMETERS.( 'eventMultRange' ) = [1 26];
            
        case 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sKInf_eF10.0mHz_eM6_nS0-8'
            PARAMETERS.( 'noiseSTDRange' ) = [0 8];
            
        case 'HEX12_K10_medium__T3600s_dT500ms_cT1s_sK0-1000_eF10.0mHz_eM6_nS0'
            PARAMETERS.( 'saturationKRange' ) = [0 1000];
            
    end
    
    
    for i = 1:400
        
        ID = [ SERIES{:} '__' num2str( i ) ];
        OUTPUT_DIRECTORY_ = [ OUTPUT_DIRECTORY '_' SERIES{:} '/' ];
        
        ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( OUTPUT_DIRECTORY_ , ID , NaN , PARAMETERS.( 'T_durationRange' ) , PARAMETERS.( 'dT_durationRange' ) , PARAMETERS.( 'assembly_configuration_list' ) , i , PARAMETERS.( 'calcium_T1_2Range' ) ,  PARAMETERS.( 'eventFreqRange' ) , PARAMETERS.( 'eventMultRange' ) , PARAMETERS.( 'noiseSTDRange' ) , PARAMETERS.( 'saturationKRange' ) );
    end
end