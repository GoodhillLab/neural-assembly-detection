%% 400 EXAMPLES OF ASSEMBLY CONFIGURATIONS WITH 10 ASSEMBLIES IN A HONEYCOMB STRUCTURED TECTUM
% THERE ARE 40 CONFIGURATIONS WHICH ARE EMBEDDED IN TECTA OF INCREASING
% DEGREE v = 8 , ... 17
%
% THE ASSEMBLIES WERE CREATED IN HONEYCOMB STRUCTURED TECTUM OF DEGREE 8
% FROM n = 36 POINTS DRAWN FROM A 2D-NORMAL DISTRIBUTION WITH STANDARD
% DEVIATION s UNIFORMLY IN sqrt([1.5 3.0])
%
% THE SIZE OF ASSEMBLIES IN TERM OF PARTICIPATING UNITS RANGES 15 - 25

%
%
%   === Jan Moelter, The University of Queensland, 2017 ===================
%

function [ X ] = HEXv_K10_large()

for t = 0:9
    
    % THE UNDERLYING TOPOLOGY
    T = hexagonal_tiling( 8 + t );
    
    % THE SET OF ASSEMBLY-CONFIGURATION
    X{ 40 * t + 1 } = struct( 'T' , { T } , 'A' , { { uint16( [2,3,4,5,7,8,10,11,13,15,16,18,19,23,28,30,35,60] ) , uint16( [1,2,4,6,8,9,10,17,18,19,20,21,32,35,36,51,55,57,61,63,125,127,163] ) , uint16( [2,4,7,10,11,12,13,22,23,25,26,39,40,41,43,44,45,69,70] ) , uint16( [10,23,27,42,44,66,67,68,69,70,72,95,100,101,102,133,134,136,137,138,139,140,178,179,181] ) , uint16( [17,57,58,85,87,88,119,121,122,123,158,159,160,161,162,164,165,166,207,208] ) , uint16( [8,20,22,23,40,41,42,65,66,95,96,97,129,131,132,133,135,169,176,180] ) , uint16( [34,55,57,58,59,85,86,87,88,89,120,121,122,123,124,125,162,163,165,207,212,214] ) , uint16( [7,17,32,34,55,56,57,58,83,84,85,88,117,118,119,120,159,160,203,207] ) , uint16( [1,4,7,8,9,11,19,20,21,23,37,41,58,60,63,65,66,69,89,91,94,128,132] ) , uint16( [8,36,37,38,39,40,41,61,63,64,65,90,91,92,93,94,95,126,127,129,168,169,171,173,174] ) } } );
    X{ 40 * t + 2 } = struct( 'T' , { T } , 'A' , { { uint16( [28,50,51,73,78,79,110,111,112,113,150,152,153,154,193,196,197,198] ) , uint16( [8,17,18,19,33,34,35,37,58,59,60,84,85,86,87,88,89,90,91,125,165,214] ) , uint16( [38,61,90,92,124,125,126,127,128,167,169,213,215,216] ) , uint16( [14,26,28,29,30,49,50,51,73,75,76,77,108,109,110,111,145,147,150] ) , uint16( [16,17,18,29,33,34,55,56,80,81,82,83,84,117,119,120] ) , uint16( [2,33,34,35,36,57,58,60,84,87,88,89,90,119,120,122,123,124,162,164,165,214] ) , uint16( [88,162,164,165,166,209,210,211,212] ) , uint16( [3,5,8,9,20,21,22,24,37,38,39,40,41,61,64,65,67,90,91,95,166,172] ) , uint16( [3,9,10,12,21,22,23,24,25,26,41,43,44,45,46,68,70,99,100,137] ) , uint16( [62,63,92,93,95,128,129,130,131,134,167,170,173,174,216,217] ) } } );
    X{ 40 * t + 3 } = struct( 'T' , { T } , 'A' , { { uint16( [8,13,14,15,47,48,50,52,53,55,72,73,75,76,78,80,106,107,109,111,143] ) , uint16( [28,78,79,80,110,111,112,113,150,151,152,153,154,193,196,197,198,199] ) , uint16( [50,51,52,76,77,78,79,81,109,110,111,113,150,151,152,153,195,196,197,199] ) , uint16( [4,5,12,13,16,26,27,28,29,30,33,46,47,48,49,50,51,73,74,75,77,106,110] ) , uint16( [5,7,16,18,19,33,34,35,36,54,56,57,58,59,60,61,84,86,87,89,162,207] ) , uint16( [43,64,66,95,96,97,98,131,132,134,174,175,176,178,180] ) , uint16( [11,17,21,23,25,26,43,66,67,69,70,71,74,99,100,101,103,131,136,138,140,142,182,183,186] ) , uint16( [8,9,20,21,22,23,24,39,40,41,43,63,64,66,92,93,94,95,96,130,131,133,135,173] ) , uint16( [49,50,77,78,109,111,112,113,149,150,151,192,194,195,197] ) , uint16( [1,3,4,5,6,13,14,16,17,25,29,30,31,33,46,50,51,53,54,77,78,79,111,115,116] ) } } );
    X{ 40 * t + 4 } = struct( 'T' , { T } , 'A' , { { uint16( [38,62,89,123,124,125,126,127,166,167,168,169,213,215,217] ) , uint16( [71,101,102,103,104,105,106,137,139,141,142,143,181,182,183,184,185] ) , uint16( [6,7,9,16,18,34,35,37,55,57,58,84,85,86,87,88,89,90,118,123,162] ) , uint16( [16,34,35,54,56,57,58,84,85,86,88,118,119,120,121,123,158,159,160,161,164,206] ) , uint16( [9,20,39,40,60,62,63,65,66,93,94,95,96,127,130,131,132,134,172,173,174] ) , uint16( [16,17,18,31,35,54,55,56,57,81,82,84,85,86,87,121,159] ) , uint16( [54,56,58,82,83,84,85,86,117,118,119,120,121,122,157,159,160,205] ) , uint16( [31,33,35,56,57,58,85,86,87,88,119,120,121,122,123,159,161,165] ) , uint16( [72,74,75,105,139,142,143,144,146,147,184,186,187,188,190] ) , uint16( [51,54,55,79,80,81,82,83,84,113,114,115,116,117,152,153,154,156,197,198,199,200,204] ) } } );
    X{ 40 * t + 5 } = struct( 'T' , { T } , 'A' , { { uint16( [8,38,62,64,92,128,130,131,168,172,173,174,213] ) , uint16( [3,23,25,26,42,45,66,67,68,70,96,98,99,100,101,135,138,139,177,178,179,180,181] ) , uint16( [51,76,77,108,109,110,146,147,148,149,150,191,193,194,195] ) , uint16( [58,59,89,90,91,123,124,126,127,165,166,167,172,212,214,215,217] ) , uint16( [32,55,56,84,85,86,87,119,120,121,122,159,160,161,162,205,207] ) , uint16( [29,48,49,50,70,74,76,77,78,106,107,108,109,110,113,145,147,148,190,191] ) , uint16( [17,31,32,34,35,55,56,57,58,59,84,85,86,87,118,119,120,121,160,161] ) , uint16( [2,4,7,12,16,18,21,33,34,36,40,55,56,57,59,60,61,85,86,215] ) , uint16( [51,52,77,79,80,110,111,112,113,148,149,150,151,152,195,197,198] ) , uint16( [11,23,25,40,41,42,43,44,45,67,68,69,97,99,100,101,102,134,136,137,175,180,181,182] ) } } );
    X{ 40 * t + 6 } = struct( 'T' , { T } , 'A' , { { uint16( [83,84,85,115,116,117,118,119,120,122,156,157,158,161,164,200,203,204,205,207] ) , uint16( [1,2,3,6,7,9,10,11,15,19,21,24,25,30,36,37,40,42,45,63,68] ) , uint16( [80,113,114,115,151,153,155,198,199,200,201] ) , uint16( [35,36,38,59,86,90,91,121,124,125,161,164,165,166,167,168,212,213,214] ) , uint16( [7,16,17,18,33,34,35,36,57,58,59,84,85,87,88,118,119] ) , uint16( [54,114,115,116,117,153,154,155,156,157,158,201,203] ) , uint16( [1,2,3,5,6,7,9,17,18,19,22,31,36,37,56,59,61,64,93] ) , uint16( [24,43,44,68,69,70,72,98,99,100,135,136,137,139,140,181,182,183] ) , uint16( [16,29,32,34,35,37,53,54,55,56,57,58,80,82,84,85,86,119,158,206,207] ) , uint16( [50,53,54,80,81,82,83,114,115,116,119,153,154,156,199,200] ) } } );
    X{ 40 * t + 7 } = struct( 'T' , { T } , 'A' , { { uint16( [14,15,30,33,49,50,51,52,54,55,56,59,78,79,80,83,84,115,116,117,158,202] ) , uint16( [32,52,53,54,55,80,81,82,83,86,114,115,116,117,157,200,201,205] ) , uint16( [1,4,6,7,8,12,17,19,20,21,22,25,34,35,37,58,60,79,89,91,93,95,127,168] ) , uint16( [3,37,38,58,59,60,88,91,124,125,126,128,164,165,167,169,212,213] ) , uint16( [22,25,40,41,42,43,44,65,66,67,68,70,94,97,98,99,132,134,135,136,137,138,180] ) , uint16( [2,3,23,24,39,42,43,44,66,67,68,95,96,99,100,101,133,137,141] ) , uint16( [29,47,71,73,74,75,104,105,106,107,109,141,143,144,145,189,190] ) , uint16( [1,4,8,11,22,23,24,25,40,43,44,45,65,67,68,69,71,94,95,98,101,102,137] ) , uint16( [22,66,67,69,94,98,133,134,135,136,176,177,178] ) , uint16( [68,69,97,99,101,135,136,137,178,179,181] ) } } );
    X{ 40 * t + 8 } = struct( 'T' , { T } , 'A' , { { uint16( [53,54,55,56,80,82,83,84,86,115,116,117,118,119,155,159,204,206,207] ) , uint16( [53,55,56,57,82,83,85,115,116,117,118,119,120,157,158,159,160,205,206,207] ) , uint16( [5,13,25,26,27,28,29,31,45,46,47,49,50,71,72,73,74,75,103,144,146] ) , uint16( [17,32,35,36,55,56,57,58,60,86,87,120,123,124,162,165,208] ) , uint16( [98,101,135,136,137,138,179,180,181,182,183] ) , uint16( [53,55,56,81,82,83,84,116,117,118,119,154,156,157,203,204,207] ) , uint16( [16,17,53,56,76,77,79,80,109,110,111,112,114,115,150,152,153,154,191,197,198] ) , uint16( [44,69,71,72,100,102,103,104,107,139,141,182,183,184,187] ) , uint16( [64,65,95,98,128,131,132,133,173,174,175,176] ) , uint16( [50,51,52,75,77,78,79,106,109,110,111,112,114,146,147,148,149,151,152,153,191,193,194,195,200] ) } } );
    X{ 40 * t + 9 } = struct( 'T' , { T } , 'A' , { { uint16( [22,63,66,67,95,96,99,131,132,133,134,173,174,175,180] ) , uint16( [27,28,47,49,50,51,74,75,76,106,107,108,109,145,147,190,191] ) , uint16( [15,24,30,32,33,51,52,53,54,55,79,80,82,83,112,113,114,150,151,152,153,155,198] ) , uint16( [32,51,54,55,79,80,82,83,111,112,115,118,151,153,154,155,156] ) , uint16( [43,68,70,71,72,99,100,101,102,103,104,138,140,141,142,144,183,184] ) , uint16( [54,79,80,81,82,84,113,114,115,116,117,118,156,157,158,159,204,205] ) , uint16( [12,13,14,26,28,29,30,46,48,49,50,51,52,74,76,77,78,106,107,150] ) , uint16( [14,48,49,51,74,75,76,77,78,108,109,111,112,147,148,149,150,151,192] ) , uint16( [3,4,8,9,10,11,20,21,22,23,24,26,27,39,41,42,44,46,68,70,71] ) , uint16( [8,18,19,20,35,36,58,59,60,86,89,90,92,121,123,124,125,162,165] ) } } );
    X{ 40 * t + 10 } = struct( 'T' , { T } , 'A' , { { uint16( [23,40,41,64,65,66,67,68,96,99,132,133,134,137,138,140,175,176,177] ) , uint16( [46,49,74,104,105,106,143,144,145,146,187,188,189,190] ) , uint16( [50,52,78,79,80,109,110,111,112,113,114,115,151,152,153,154,196,198] ) , uint16( [26,28,45,72,73,103,104,105,107,110,142,144,145,146,187,188,189] ) , uint16( [21,22,24,42,43,45,66,67,69,70,71,96,98,99,100,101,102,135,136,137,175,176,178] ) , uint16( [1,2,4,6,7,8,9,10,16,17,18,19,36,37] ) , uint16( [1,4,9,10,11,22,24,25,26,27,42,43,46,68,70,73,101] ) , uint16( [28,48,72,73,74,102,103,104,106,107,109,142,144,145,147,187,188,190] ) , uint16( [15,55,81,82,83,84,85,116,117,118,119,120,156,158,160,161,205,206] ) , uint16( [20,39,63,92,93,94,125,127,128,130,167,169,215,216,217] ) } } );
    X{ 40 * t + 11 } = struct( 'T' , { T } , 'A' , { { uint16( [24,26,45,46,49,71,72,73,101,102,103,104,105,140,141,142,143,146,183,186,189] ) , uint16( [3,4,7,10,11,12,15,25,26,27,28,30,44,45,46,48,49,67,70,71,73,75,99,103,106,145,150] ) , uint16( [20,38,62,63,64,93,94,95,96,127,128,129,130,133,169,171,173] ) , uint16( [3,4,8,9,18,19,21,22,23,24,30,35,36,39,40,41,59,61,63,71,91,93,95,126] ) , uint16( [1,4,11,12,14,15,24,25,26,27,28,44,47,48,49,51,72,74,104,144] ) , uint16( [43,63,67,68,69,96,98,133,134,136,137,176,177] ) , uint16( [5,7,8,19,20,21,22,37,39,40,41,42,59,62,63,64,66,67,68,91,93,96,130] ) , uint16( [30,32,53,54,55,78,81,82,83,84,87,115,116,117,119,154,156,158,199,203] ) , uint16( [24,46,68,69,98,99,100,137,138,139,140,181,182,183,184] ) , uint16( [16,33,55,56,57,58,81,83,84,85,117,120,123,154,159,160,204,205,206,208] ) } } );
    X{ 40 * t + 12 } = struct( 'T' , { T } , 'A' , { { uint16( [52,54,75,78,79,80,109,112,113,114,148,150,151,152,153,196,197,198] ) , uint16( [38,61,62,64,65,93,94,95,128,129,131,169,171,172,173,174] ) , uint16( [34,35,56,57,59,83,84,85,86,87,88,119,120,121,158,159,161,162,163,164,208] ) , uint16( [39,40,41,62,63,64,67,94,95,97,129,131,132,173] ) , uint16( [21,41,42,43,63,66,67,68,69,96,97,98,130,131,132,133,134,136,137,174,175,176] ) , uint16( [2,3,4,5,7,9,10,11,19,20,21,22,24,38,39,40,41,59,62,66,74,94] ) , uint16( [14,15,16,29,30,31,49,50,51,52,54,78,79,80,111,113,114,116,152,200] ) , uint16( [63,66,93,94,127,128,130,131,132,172,173,174] ) , uint16( [2,6,16,17,30,32,33,34,51,52,53,54,55,57,59,60,79,80,84,85,119,121,155,161] ) , uint16( [29,32,51,74,77,79,82,109,110,111,112,113,114,148,149,150,151,193,195,196] ) } } );
    X{ 40 * t + 13 } = struct( 'T' , { T } , 'A' , { { uint16( [29,30,49,50,52,54,77,78,79,111,113,114,115,149,150,151,152,192,195,196,197,199] ) , uint16( [51,75,76,77,79,107,109,110,111,144,147,148,150,191,192,193,194,195,196] ) , uint16( [1,5,8,9,10,17,18,19,27,33,34,35,37,38,55,59,61,62,85,89,91] ) , uint16( [7,8,10,21,22,23,40,42,64,66,67,92,93,94,96,97,125,132,133,136,175] ) , uint16( [33,55,81,84,85,89,114,117,119,120,121,157,160,161,162,204,205,206,208,209] ) , uint16( [14,78,109,110,111,113,149,150,151,152,153,192,193,195,196] ) , uint16( [23,25,42,65,66,67,68,70,95,96,99,134,135,137,138,176,179,180,181] ) , uint16( [2,3,9,10,11,12,22,24,25,26,27,42,43,44,45,46,69,70,71,99,100] ) , uint16( [1,4,5,6,14,16,17,18,19,30,31,34,35,54,55,57,60,82,84,86,87,88,118,119,125,159,162] ) , uint16( [1,6,9,13,14,15,16,18,28,29,30,31,32,37,49,51,52,53,54,80,81,84,113] ) } } );
    X{ 40 * t + 14 } = struct( 'T' , { T } , 'A' , { { uint16( [62,63,90,91,92,95,127,128,129,167,168,171,172,217] ) , uint16( [7,16,18,19,33,34,35,36,56,57,58,85,86,87,118,119,120,121] ) , uint16( [4,5,6,7,8,14,16,17,18,19,33,34,35,36,54,55,56,59,82,83,85,158] ) , uint16( [58,59,88,89,90,91,122,123,124,163,164,165,166,167,211,212,213] ) , uint16( [4,15,17,30,31,32,33,53,54,55,79,80,81,82,85,114,117,119,155] ) , uint16( [37,38,61,63,91,93,94,127,128,129,131,169,170,171,174,214,215,217] ) , uint16( [4,5,6,12,13,15,16,17,18,28,29,30,31,32,33,34,79] ) , uint16( [30,31,73,78,110,147,148,190,191,192,193,194,196,197] ) , uint16( [2,3,4,6,7,13,14,16,17,18,19,30,32,33,34,35,36,37,51,53,54,55,56,57,59,89] ) , uint16( [1,11,14,18,28,30,48,49,51,74,76,77,78,79,105,106,108,109,110,112,145,146,147] ) } } );
    X{ 40 * t + 15 } = struct( 'T' , { T } , 'A' , { { uint16( [41,45,67,68,69,70,71,101,102,103,136,138,139,140,182] ) , uint16( [4,26,27,28,29,45,46,48,49,70,71,73,74,75,102,105,107,144,146,193] ) , uint16( [40,41,42,43,65,66,67,68,69,96,97,98,99,132,133,134,136] ) , uint16( [2,6,16,33,34,53,54,56,57,58,59,85,86,87,88,89,90,117,119,120,122,123,208] ) , uint16( [52,82,111,112,113,115,149,151,152,153,154,155,157,195,196,197,200] ) , uint16( [31,33,57,82,83,84,85,117,118,119,157,158,159,160,203,204] ) , uint16( [5,30,31,50,51,52,53,75,77,79,82,109,111,112,113,114,148,149,150,151,153] ) , uint16( [28,43,46,68,102,104,105,139,140,142,143,145,182,183,185,187] ) , uint16( [2,3,5,6,7,9,11,13,14,15,16,17,19,31,32,33,52,74,81] ) , uint16( [80,81,82,113,114,116,153,154,155,197,198,199,200,201] ) } } );
    X{ 40 * t + 16 } = struct( 'T' , { T } , 'A' , { { uint16( [7,8,9,10,17,18,19,33,34,35,54,56,58,59,60,61,83,85,86,87,119,120,122,125,160] ) , uint16( [21,22,24,25,37,38,39,40,41,61,62,64,65,66,92,94,96,128,132] ) , uint16( [33,34,54,55,56,57,82,83,87,116,117,118,119,156,157,158,159,160,199,205] ) , uint16( [3,11,23,25,26,27,43,44,45,68,70,72,100,101,104,105,136,137,139,183,184,188] ) , uint16( [18,33,35,36,57,83,84,87,88,118,119,121,122,159,160,161,206,207,209] ) , uint16( [3,4,5,6,12,13,14,15,16,27,29,30,31,48,49,53,76,77,80,107] ) , uint16( [32,54,55,56,81,82,115,116,117,154,155,156,158,200,201,203,204,205] ) , uint16( [41,42,66,68,70,97,98,133,134,136,137,138,176,177,180,181] ) , uint16( [76,108,110,145,146,147,148,190,191,192] ) , uint16( [16,32,33,53,54,56,82,83,84,85,117,119,120,155,157,158,160,205] ) } } );
    X{ 40 * t + 17 } = struct( 'T' , { T } , 'A' , { { uint16( [26,46,69,72,101,103,104,105,140,143,144,185,187,188] ) , uint16( [35,37,54,55,56,57,58,84,86,87,88,118,119,120,121,158,159,160,161,162,164,210] ) , uint16( [1,4,11,12,13,14,24,25,26,27,29,46,47,48,49,70,72,73,74,75,142,144] ) , uint16( [1,2,3,10,11,12,21,22,23,24,25,40,41,43,64,65,66,68,70,96,101,137] ) , uint16( [1,2,3,8,18,19,20,21,22,34,35,36,37,38,40,41,44,57,59,60,64,86,89,90,168] ) , uint16( [36,57,58,59,61,62,63,86,87,89,122,123,124,125,126,161,162,164,166,212,213,214,215] ) , uint16( [11,12,26,27,29,44,45,46,47,48,49,70,73,74,75,76,102,103,144,145] ) , uint16( [2,3,8,9,10,12,20,22,23,24,39,40,44,62,63,64,65,66,93,94,95,134] ) , uint16( [18,35,36,56,57,58,60,85,86,87,89,122,123,124,125,163,164,165,166,212] ) , uint16( [38,64,93,94,96,129,130,131,132,133,134,171,173,176] ) } } );
    X{ 40 * t + 18 } = struct( 'T' , { T } , 'A' , { { uint16( [5,6,7,10,12,13,14,16,27,29,30,32,49,50,55,74,103,108,153] ) , uint16( [1,3,4,6,7,10,12,13,14,15,19,22,23,25,26,27,28,40,42,44,45,48,59,102,105,107] ) , uint16( [2,20,21,60,61,62,90,92,122,124,127,166,168,169,170,214,215,216,217] ) , uint16( [35,56,58,86,87,88,121,122,123,124,161,162,163,164,165,166,209,210,212] ) , uint16( [84,116,117,155,156,157,158,159,160,201,203,204,205,206] ) , uint16( [22,41,64,65,94,96,98,130,131,133,173,175,176,177,178] ) , uint16( [49,50,109,112,113,115,149,150,151,152,196,197] ) , uint16( [3,7,8,9,10,13,18,19,20,21,24,25,38,39,40,41,42,61,65,67] ) , uint16( [1,4,5,10,12,13,14,26,27,28,29,45,46,47,48,49,106,109,145] ) , uint16( [7,19,21,22,23,39,40,62,63,64,65,68,91,94,95,100,129,130,131,132] ) } } );
    X{ 40 * t + 19 } = struct( 'T' , { T } , 'A' , { { uint16( [53,81,112,114,115,116,117,151,153,154,155,157,198,199,200,201] ) , uint16( [1,2,3,5,6,7,9,12,15,16,18,19,37,54,56,59,60,80] ) , uint16( [39,41,42,62,64,65,66,67,94,95,96,97,98,130,131,135,174,176,216] ) , uint16( [15,50,77,109,111,112,113,114,148,149,150,151,152,153,196,197,198,199] ) , uint16( [19,20,21,38,39,62,63,64,65,89,90,92,93,94,130,131,169] ) , uint16( [51,77,108,109,110,111,113,147,148,150,152,191,193,195] ) , uint16( [27,28,29,47,48,49,50,74,75,76,78,79,106,107,109,111,112,144,145,146,147,152] ) , uint16( [86,88,89,90,123,124,125,164,166,168,206,209,212,213,214] ) , uint16( [62,63,64,65,92,94,127,128,129,130,168,170,171,172,173,174,216] ) , uint16( [38,39,40,61,63,91,92,93,94,95,96,128,129,130,131,132,171,172,173,216] ) } } );
    X{ 40 * t + 20 } = struct( 'T' , { T } , 'A' , { { uint16( [13,29,30,48,49,50,51,52,53,55,78,79,80,109,110,112,113,115,148,152] ) , uint16( [6,15,34,55,56,57,58,83,84,85,86,88,114,118,119,120,122,203] ) , uint16( [56,57,86,87,88,120,121,122,123,161,162,163,165,205,206,207,209] ) , uint16( [13,25,28,29,46,47,48,49,71,72,73,74,75,76,77,78,105,106,140,143,144,146,147,189] ) , uint16( [41,65,94,95,96,97,98,132,133,134,135,174,176] ) , uint16( [59,92,93,94,95,127,128,129,130,132,170,173,174,216] ) , uint16( [20,34,35,36,56,57,58,59,60,84,87,89,90,121,122,123,125,163,167,213] ) , uint16( [3,10,24,41,42,43,44,64,66,67,68,72,96,99,100,133,134,137,139,178,179,181] ) , uint16( [97,98,99,132,133,134,135,176,177,179,180] ) , uint16( [2,6,7,9,11,16,17,18,19,31,33,36,55,56,58,59,82,83,84,85,119,121,124] ) } } );
    X{ 40 * t + 21 } = struct( 'T' , { T } , 'A' , { { uint16( [62,89,123,124,126,128,164,166,167,168,169,211,213,214,215,216] ) , uint16( [76,106,107,108,109,110,146,147,148,149,191,192] ) , uint16( [63,65,93,95,96,97,132,133,173,174,175,176,177] ) , uint16( [11,26,28,30,45,46,47,48,49,71,73,74,75,76,107,144,145,146,189,191] ) , uint16( [32,52,54,79,82,114,115,116,120,151,152,153,154,157,200] ) , uint16( [51,54,80,82,113,114,115,116,117,120,153,154,156,200,201,202,205] ) , uint16( [4,5,9,11,12,13,19,24,25,26,27,29,44,45,46,48,74,101,102,108,142] ) , uint16( [40,62,63,64,67,91,92,95,96,129,131,132,133,173,175,177,216] ) , uint16( [16,32,33,54,55,56,80,81,82,83,114,115,116,117,118,154,157] ) , uint16( [1,3,4,6,7,8,9,10,12,18,19,20,22,23,25,36,38,40,42,65] ) } } );
    X{ 40 * t + 22 } = struct( 'T' , { T } , 'A' , { { uint16( [51,76,77,109,110,111,112,147,148,149,150,193,194,195,197] ) , uint16( [62,63,65,90,91,92,93,127,128,129,130,168,169,170,172,216] ) , uint16( [53,54,81,115,116,117,118,119,120,155,156,158,201,202,204] ) , uint16( [30,50,52,76,77,110,111,149,151,192,193,194,195,196,197] ) , uint16( [20,39,62,89,91,92,125,126,127,128,129,130,131,132,166,168,169,171,215,216,217] ) , uint16( [87,120,121,122,161,162,163,164,165,166,167,208,209,210,211,212] ) , uint16( [15,29,30,31,50,51,76,77,79,80,108,110,111,112,113,148,149,150,151] ) , uint16( [49,72,73,75,107,109,111,145,146,147,149,151,189,190,192,193,195] ) , uint16( [51,52,78,79,110,112,115,151,152,154,194,195,197,198,200] ) , uint16( [14,49,51,77,79,108,110,111,146,147,148,149,150,151,152,189,191,195,196] ) } } );
    X{ 40 * t + 23 } = struct( 'T' , { T } , 'A' , { { uint16( [14,52,54,56,78,79,80,81,82,83,84,113,114,115,117,152,154,155,201,202,203] ) , uint16( [1,3,4,6,11,12,13,17,24,27,29,31,45,46,48,49,51,69] ) , uint16( [26,50,74,75,76,79,107,108,109,147,148,149,190,191,193] ) , uint16( [27,48,73,74,75,77,78,106,108,109,110,143,144,146,147,148,150,189,192,193] ) , uint16( [5,12,13,14,16,26,27,28,29,47,48,49,51,75,76,78,110,147,148] ) , uint16( [36,57,59,87,88,120,122,123,124,163,165,168,209,210,211,212] ) , uint16( [3,8,9,10,21,39,41,42,43,61,63,64,66,67,94,95,96,97,100,130,133,173,175,180] ) , uint16( [1,4,5,7,8,10,15,17,18,34,35,36,37,56,57,59,60,61,81,84,89] ) , uint16( [88,89,124,125,126,163,166,167,168,212,213,214,215,216] ) , uint16( [1,4,5,6,7,14,15,16,17,18,25,29,30,32,33,34,35,52,55,56,81,116] ) } } );
    X{ 40 * t + 24 } = struct( 'T' , { T } , 'A' , { { uint16( [1,5,7,16,17,18,33,34,35,54,55,56,57,59,80,82,85,119,120,157] ) , uint16( [4,20,37,38,60,62,63,64,90,91,92,93,125,126,127,128,166,169,173,212,214,216] ) , uint16( [59,87,88,89,121,122,123,124,162,163,164,208,209,210,211,212] ) , uint16( [24,26,45,46,67,69,70,71,72,100,102,139,140,145,182,183,185] ) , uint16( [16,17,18,33,34,35,55,56,57,58,59,60,85,86,87,119,120,121,123] ) , uint16( [20,22,39,41,64,65,66,67,94,96,130,131,132,133,134,173,174,175,176] ) , uint16( [65,67,98,99,100,101,133,135,137,138,139,176,177,179,181,182] ) , uint16( [2,3,10,11,20,22,23,24,25,40,41,42,43,44,63,64,65,66,100] ) , uint16( [34,56,58,84,86,87,89,90,119,120,121,122,160,161,205,206,207] ) , uint16( [62,63,64,65,93,96,97,130,131,132,133,169,172] ) } } );
    X{ 40 * t + 25 } = struct( 'T' , { T } , 'A' , { { uint16( [39,62,63,92,93,94,95,129,131,132,133,168,171,172,173,174,217] ) , uint16( [31,52,53,81,113,114,115,116,152,153,156,197,199,200,201,202] ) , uint16( [6,16,17,32,33,34,54,55,56,57,80,83,84,85,86,88,118,120,158] ) , uint16( [11,12,24,25,26,41,44,45,46,49,68,70,71,72,102,137,139] ) , uint16( [34,35,36,56,58,59,60,86,87,88,89,90,123,124,125,164,165,166,210,214] ) , uint16( [16,31,32,53,54,56,82,83,84,87,116,117,118,119,120,158,159,160,161,205,207] ) , uint16( [37,62,89,91,122,124,125,126,127,165,166,167,168,209,214,215] ) , uint16( [11,22,23,40,42,43,45,65,66,68,69,70,95,96,97,98,99,100,137,138,180] ) , uint16( [12,26,27,28,29,47,49,50,51,52,74,75,76,77,78,106,109,112,113,147,149] ) , uint16( [31,32,52,53,79,80,82,83,113,114,115,116,118,153,155,156,157,158,200] ) } } );
    X{ 40 * t + 26 } = struct( 'T' , { T } , 'A' , { { uint16( [2,8,19,22,23,37,38,39,60,62,63,64,90,91,93,125,126,128,167,169,172] ) , uint16( [49,73,76,109,111,145,146,148,190,192,193,194] ) , uint16( [24,26,42,43,44,45,67,68,70,71,99,100,101,102,103,138,139,145,182,184] ) , uint16( [21,39,41,62,63,64,65,66,94,95,96,126,127,129,131,132,133,172,176,177] ) , uint16( [1,2,3,5,6,7,10,11,12,13,14,15,16,26,28,30,49,50,51,52,101] ) , uint16( [63,64,91,95,97,129,130,131,132,133,172,173,174,175,176] ) , uint16( [12,28,43,44,45,50,70,72,73,103,104,105,106,108,143,145,187,188,189,191,194] ) , uint16( [38,62,91,92,128,129,130,168,169,216,217] ) , uint16( [90,91,92,124,125,126,127,167,168,169,214,215,216,217] ) , uint16( [1,3,14,25,26,27,28,32,44,45,46,47,51,69,70,72,73,101,102,140,144] ) } } );
    X{ 40 * t + 27 } = struct( 'T' , { T } , 'A' , { { uint16( [24,45,68,99,100,101,102,135,137,138,139,140,183,186] ) , uint16( [4,9,10,19,21,23,24,25,41,42,43,44,45,67,68,69,70,96,99,100,101,135,136,138] ) , uint16( [1,2,4,6,7,8,10,13,14,15,16,17,19,23,26,30,34,36,37,53,54,57,77,83,84,86] ) , uint16( [17,34,56,57,58,83,84,86,87,88,120,121,122,123,160,161,162,164,165,166,208,209,210] ) , uint16( [16,29,30,50,51,52,53,77,79,80,82,111,112,113,114,115,151,152,198] ) , uint16( [110,113,114,115,148,152,153,154,156,195,196,197,198,199,200] ) , uint16( [15,33,81,84,86,114,115,117,155,157,158,159,200,201,202,203,206] ) , uint16( [58,85,120,121,122,123,159,160,161,162,163,164,205,208,209,211] ) , uint16( [58,60,86,89,121,123,124,126,164,165,166,167,209,211,212,213,215] ) , uint16( [22,39,40,41,42,43,63,64,65,67,91,94,96,98,129,130,132,174] ) } } );
    X{ 40 * t + 28 } = struct( 'T' , { T } , 'A' , { { uint16( [41,63,65,92,94,95,96,97,98,130,131,134,172,173,174,175,176,177] ) , uint16( [17,18,56,57,58,59,60,85,86,87,88,89,119,120,121,122,126,159,160,161,162,206] ) , uint16( [23,24,39,41,64,65,66,67,94,95,97,132,133,134,135,136,173,175,176] ) , uint16( [46,47,48,49,73,74,76,105,107,108,142,143,145,147,149,189,191,193] ) , uint16( [46,73,101,102,103,138,181,182,183,184,185] ) , uint16( [39,63,64,93,94,95,128,129,130,131,171,172,173,174] ) , uint16( [2,3,9,11,13,14,28,29,30,48,49,50,51,53,74,79,107,109,112] ) , uint16( [12,23,24,25,26,41,42,43,44,66,68,69,70,99,100,101,102,137,138,139] ) , uint16( [4,14,26,29,31,46,49,50,51,74,75,76,79,107,109,110,111,146,147,149,190,191] ) , uint16( [38,89,90,91,123,125,126,127,128,165,166,169,208,213,214,216] ) } } );
    X{ 40 * t + 29 } = struct( 'T' , { T } , 'A' , { { uint16( [3,4,11,12,24,25,26,27,43,45,46,47,48,70,71,72,101] ) , uint16( [65,66,67,94,97,99,132,133,134,135,136,171,173,174,175,176,178] ) , uint16( [1,6,14,16,29,30,31,32,50,51,52,53,76,77,78,79,81,111,112,113,114] ) , uint16( [3,8,9,10,22,23,24,25,26,28,41,42,43,44,45,46,65,71,94,98,100] ) , uint16( [8,11,20,22,38,40,41,62,65,93,94,126,129,130,131,132,133,173,176,217] ) , uint16( [2,4,5,6,7,8,9,10,11,16,18,19,20,21,22,37,39,90] ) , uint16( [33,34,86,87,119,155,159,161,162,205,206,207,208,209] ) , uint16( [27,29,50,51,54,76,77,78,79,80,110,111,112,150,152,191,194,195,196] ) , uint16( [9,20,38,39,59,60,61,62,63,64,89,90,91,95,124,125,126,127,129,131,171] ) , uint16( [65,66,93,94,95,98,127,130,131,132,133,171,172,173,175,176] ) } } );
    X{ 40 * t + 30 } = struct( 'T' , { T } , 'A' , { { uint16( [14,15,29,32,33,53,79,80,81,83,109,111,112,117,119,154,155,199,200] ) , uint16( [26,45,46,70,72,73,101,102,103,104,105,141,142,144,182,183,185,187] ) , uint16( [2,20,34,37,58,60,62,63,64,89,90,92,93,124,125,126,127,128,131,166,216] ) , uint16( [3,8,9,19,20,37,38,59,60,61,62,64,90,91,93,94,126,127,130,168,169,213] ) , uint16( [28,45,46,47,71,72,73,103,106,139,142,184,185,186,187,188,189,191] ) , uint16( [18,34,54,55,83,84,86,118,119,121,123,153,157,158,159,161,202,204,205] ) , uint16( [2,8,18,36,39,57,63,91,93,94,123,125,126,127,129,130,132,166,167,168,169,172,215,216] ) , uint16( [9,23,42,65,66,67,68,95,96,97,98,99,100,132,133,134,175,176,177,179] ) , uint16( [28,29,30,32,48,49,50,53,54,76,77,78,79,82,110,111,113,147,151,153,198] ) , uint16( [26,71,72,101,103,137,138,140,141,182,184] ) } } );
    X{ 40 * t + 31 } = struct( 'T' , { T } , 'A' , { { uint16( [4,11,12,25,26,27,43,44,45,46,47,48,71,72,73,75,101,102,105,106,144,145] ) , uint16( [8,9,14,19,20,21,22,36,37,38,39,40,59,60,61,62,63,65,89,91,94,127] ) , uint16( [45,72,73,74,75,107,108,109,143,144,145,146,188,189,190,192] ) , uint16( [31,53,54,79,82,83,113,115,117,152,153,154,155,156,158,198,199,200] ) , uint16( [46,74,106,107,142,143,144,186,187,189,190,191] ) , uint16( [53,80,83,113,116,118,119,156,157,159,160,200,201,203,204,205] ) , uint16( [5,6,13,16,17,31,32,33,46,50,51,52,53,54,56,78,80,81,82,112,113,114] ) , uint16( [22,42,65,67,68,69,96,97,99,101,133,134,136,177,178,180,182] ) , uint16( [29,30,49,50,51,52,53,54,76,77,78,80,110,111,112,148,151,153] ) , uint16( [20,39,60,62,64,90,91,93,125,126,127,129,130,166,167,168,169,171,213,214,216,217] ) } } );
    X{ 40 * t + 32 } = struct( 'T' , { T } , 'A' , { { uint16( [5,6,30,31,50,52,55,78,79,80,81,82,113,115,116,117,153,154,156,199,202] ) , uint16( [1,4,6,7,8,10,12,13,14,15,17,18,19,22,23,24,26,33,34,35,36,37,40,57,58,91,97] ) , uint16( [42,44,65,66,67,69,70,95,96,97,98,99,100,103,134,135,136,137,176,179,180,181] ) , uint16( [1,2,6,16,17,18,31,32,33,34,35,57,58,59,60,84,86,88,118,119] ) , uint16( [62,64,65,93,94,95,96,101,128,129,130,133,171,173,174,175,178] ) , uint16( [2,3,5,6,7,8,10,13,15,16,18,21,25,30,31,33,36,56,57,59,83,89,118] ) , uint16( [45,71,103,104,107,138,139,140,141,142,181,182,183,185,187] ) , uint16( [20,37,39,40,59,61,62,63,64,91,93,94,125,127,168,169,172] ) , uint16( [21,22,23,39,41,62,63,64,65,67,93,94,96,97,131,132,173,174,175] ) , uint16( [25,69,70,71,97,100,102,104,105,138,139,142,183] ) } } );
    X{ 40 * t + 33 } = struct( 'T' , { T } , 'A' , { { uint16( [61,88,89,92,93,124,125,127,164,165,166,167,168,169,212,214,215] ) , uint16( [79,80,81,112,114,117,149,150,151,152,153,154,155,156,195,196,199,200] ) , uint16( [77,78,110,112,113,114,151,152,153,195,196,197,198] ) , uint16( [21,22,23,38,39,40,41,42,63,64,65,66,67,68,94,95,96,97,98,178] ) , uint16( [9,20,21,22,39,40,41,61,64,65,67,90,91,92,94,95,96,126,130,131,132,133,134,176] ) , uint16( [4,6,16,27,30,31,32,35,51,52,53,54,56,79,80,81,82,83,113,114,115,151,152,153,156,200] ) , uint16( [26,45,46,48,72,75,79,106,107,109,142,143,144,145,146,190,191] ) , uint16( [1,4,5,13,25,27,28,29,30,31,46,47,48,49,68,71,77,78,109,111,142,144,145,147,149,193] ) , uint16( [8,20,22,39,60,61,63,64,65,88,91,92,94,95,96,126,128,130,167,168,169,175] ) , uint16( [3,4,5,9,10,11,12,13,21,22,23,24,25,26,27,40,43,44,45,71,107] ) } } );
    X{ 40 * t + 34 } = struct( 'T' , { T } , 'A' , { { uint16( [4,11,12,14,15,27,29,31,32,46,47,48,49,50,51,74,76,77,78,107,145,147,148,190] ) , uint16( [38,59,87,88,89,122,123,124,125,126,163,164,165,166,169,212,213,214] ) , uint16( [8,39,40,65,94,95,96,130,131,132,133,134,174,175,176] ) , uint16( [14,17,29,50,51,52,77,78,79,80,108,110,111,112,113,114,149,151,153,157] ) , uint16( [35,54,59,84,85,87,119,120,121,122,124,125,159,160,162,164,165,206,207] ) , uint16( [3,11,12,23,24,25,26,42,43,44,45,46,68,69,70,71,72,97,100,102,140] ) , uint16( [49,72,74,75,76,108,110,144,146,147,148,149,190,191,192,194] ) , uint16( [15,17,18,33,34,35,36,55,57,58,60,85,86,87,88,119,120,121,159,161,162,163,166] ) , uint16( [35,85,86,91,122,123,162,163,164,165,166,167,211,212,213,214] ) , uint16( [1,4,7,11,14,15,16,27,29,30,48,49,50,51,52,53,75,78,109,113,146,149] ) } } );
    X{ 40 * t + 35 } = struct( 'T' , { T } , 'A' , { { uint16( [14,28,29,49,51,74,75,76,78,79,80,109,110,111,146,147,148,149,150,151,189,193,195] ) , uint16( [1,2,3,5,6,7,8,9,12,13,14,15,17,18,19,21,22,24,32,35,36] ) , uint16( [16,32,33,34,35,53,54,55,56,80,81,82,83,115,116,117,118,153] ) , uint16( [32,52,53,54,81,82,113,114,116,154,155,157,158,160,200,201,203,204] ) , uint16( [3,10,11,12,23,24,25,27,41,42,44,45,46,66,69,70,71,99,100,101] ) , uint16( [24,41,61,63,65,66,67,94,95,96,97,99,128,130,132,169,173,174,175,176,177] ) , uint16( [2,6,16,17,32,33,35,55,56,57,82,83,84,85,86,119,121,159,164] ) , uint16( [1,2,9,18,21,23,36,38,40,60,61,62,63,64,65,66,90,91,93,94,95,96,172] ) , uint16( [3,11,13,22,41,43,45,68,69,98,100,101,102,138,139,180,181,182,184] ) , uint16( [1,2,3,4,5,7,8,10,13,14,15,16,17,18,30,33,51,52,53] ) } } );
    X{ 40 * t + 36 } = struct( 'T' , { T } , 'A' , { { uint16( [10,11,23,41,42,43,44,45,66,68,69,70,97,99,100,104,134,137,138,140,176,181] ) , uint16( [2,6,7,9,10,13,14,15,16,17,18,26,29,31,34,35,37,59,121] ) , uint16( [7,9,11,24,25,27,42,43,44,45,68,70,71,72,97,101,102,103,134,137,139] ) , uint16( [58,59,84,85,86,87,88,89,90,120,121,122,123,124,125,162,163,166,167,207,209,211,212] ) , uint16( [1,15,16,31,32,33,34,49,50,51,53,54,56,79,80,81,82,111,115,116,117] ) , uint16( [40,41,42,44,64,66,67,68,94,98,99,100,132,133,134,136,173,175,176,177,178,181] ) , uint16( [44,45,47,71,72,73,103,104,105,106,140,142,143,144,187,189] ) , uint16( [18,20,21,35,37,38,41,59,60,62,63,90,91,95,125,126,129,168,169] ) , uint16( [8,9,10,20,21,22,23,24,25,39,40,42,64,65,66,68,93,94,96,97,98,130,137] ) , uint16( [26,45,46,47,71,74,103,105,106,107,144,145,147,185,186,187,189] ) } } );
    X{ 40 * t + 37 } = struct( 'T' , { T } , 'A' , { { uint16( [15,34,54,55,57,79,82,113,114,115,153,155,157,158,159,160,203,204] ) , uint16( [16,17,18,19,20,33,34,35,36,39,56,63,85,88,89,90,91,125,166] ) , uint16( [20,21,22,38,60,62,63,64,91,93,95,96,127,129,131,132,169,171,216] ) , uint16( [50,74,76,108,109,110,145,146,147,148,149,151,188,189,190,191,192,194] ) , uint16( [15,18,32,33,34,54,55,56,57,60,82,83,84,85,88,117,119,120,121,159,160] ) , uint16( [33,51,54,55,80,81,83,112,114,115,116,152,154,155,158,197,198,199,200,201] ) , uint16( [21,38,60,62,89,90,91,92,93,125,126,127,128,129,131,167,170,172,173,215] ) , uint16( [44,46,72,99,100,101,102,103,104,105,138,139,140,141,184] ) , uint16( [54,82,113,114,116,117,153,154,155,156,199,200,201,203] ) , uint16( [18,34,58,59,60,85,86,87,90,91,121,122,123,124,125,127,163,164] ) } } );
    X{ 40 * t + 38 } = struct( 'T' , { T } , 'A' , { { uint16( [40,66,95,96,97,98,99,132,133,134,135,174,175,176,177] ) , uint16( [22,25,42,44,45,67,70,71,99,100,102,103,105,137,138,139,142,181,182] ) , uint16( [14,16,28,29,30,52,53,55,76,78,79,80,111,112,114,150,152,154,197,198] ) , uint16( [42,65,66,67,94,96,97,98,99,100,132,135,136,176,181] ) , uint16( [81,82,84,116,117,118,156,157,158,159,160,161,201,202,203,204,205,206] ) , uint16( [53,54,80,81,82,111,114,115,116,117,119,155,156,157,158,159,160,200,202,204,207] ) , uint16( [8,20,35,38,39,57,59,60,61,62,64,88,89,90,91,124,127,129,165,166,167,168,169] ) , uint16( [25,45,46,47,71,72,73,74,76,104,105,106,107,141,142,143,144,145,184,187,188,189,190] ) , uint16( [30,53,75,76,77,78,108,109,110,111,145,146,148,149,150,151,152,192,194,196] ) , uint16( [41,65,66,94,96,97,99,129,131,132,133,134,174,175,176,177] ) } } );
    X{ 40 * t + 39 } = struct( 'T' , { T } , 'A' , { { uint16( [32,52,53,77,80,81,82,83,114,117,152,153,154,155,156,157,199,200,201] ) , uint16( [90,91,92,93,125,126,127,128,130,167,168,169,170,172,213,215,216,217] ) , uint16( [16,17,32,33,34,53,55,56,57,58,82,85,86,118,119,120,158,159,161,204] ) , uint16( [45,69,70,71,72,102,103,104,137,138,139,140,141,142,181,184] ) , uint16( [16,18,36,56,83,85,87,119,120,121,122,123,156,159,160,162,163,204,205,206,209,210] ) , uint16( [8,20,57,58,60,85,86,87,88,89,90,122,123,159,161,162,163,164,165,166,209,213] ) , uint16( [74,105,106,107,108,143,145,146,147,189,190] ) , uint16( [5,11,25,26,28,46,47,48,70,71,72,73,74,75,102,105,106,142,189,192] ) , uint16( [1,2,3,4,5,6,7,8,9,16,21,22,23,27,31,33,36,37,39,40,60,61] ) , uint16( [27,46,74,102,104,108,140,141,142,143,183,184,185,186,187] ) } } );
    X{ 40 * t + 40 } = struct( 'T' , { T } , 'A' , { { uint16( [58,59,60,85,86,120,121,122,123,124,161,162,164,165,208,209,210] ) , uint16( [25,41,42,43,44,47,69,70,71,72,100,101,102,137,138,139,180,182] ) , uint16( [1,2,4,5,6,7,8,13,15,16,17,19,22,30,31,32,35,36,51,56,57,58,61,88] ) , uint16( [4,12,19,26,28,41,45,46,47,70,71,100,101,102,105,137,139,140,141,143,144,183,184,185,188] ) , uint16( [19,20,61,62,88,90,91,92,93,122,123,124,125,126,127,130,165,166,167,172,214,215] ) , uint16( [23,40,66,67,69,96,97,98,99,100,131,132,133,135,136,174,176,177,178] ) , uint16( [14,27,28,29,30,46,48,49,50,52,75,76,77,104,107,109,143,145,146,191] ) , uint16( [50,109,110,111,147,148,149,150,151,193,194,195,196,197] ) , uint16( [25,72,73,101,103,105,139,140,141,142,143,180,183,184,185,187,188] ) , uint16( [27,29,30,48,49,50,51,75,76,77,78,80,107,109,110,112,153] ) } } );
    
end

end