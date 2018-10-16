function [ raster , output_args ] = findSignificantFluorescenceTraces( deltaFoF , tauDecay , fps )
%FINDSIGNIFICANTFLUORESCENCETRACES( deltaFoF , tauDecay , fps )
%
% PARAMETERS:
% \_ deltaFoF: dF/F-signal
% \_ tauDecay: calcium-indicator fluorescence decay constant in units of
% seconds
% \_ fps: frame rate in units of inverse seconds (Hertz)
%
%
%   === Jan Moelter, The University of Queensland, 2018 ===================
%

params.fps = fps;
params.tauDecay = tauDecay;
params.BaselineNoiseMethod = 'Gaussian model';
params.methodSignificatTransients = 'Dynamic threshold';
params.confCutOff = 95;

movements = zeros( size( deltaFoF , 1 ) , 1 );

%% 'Step 2: Calculation of noise level in baseline fluorescence ROIs.'

[deltaFoF, mu, sigma, params]=EstimateBaselineNoise(deltaFoF, params);

deltaFoF(logical(movements),:)=NaN;

%% 'Step 3: Detection of significant fluorescence transients.'

%% 'Step 3.1: Estimating noise model.'
[densityData, densityNoise, xev, yev] = NoiseModel( '' , deltaFoF, sigma, movements , false);
[mapOfOdds] = SignificantOdds(deltaFoF, sigma, movements, densityData, densityNoise, xev, params, false);

%% 'Step 3.2: Producing raster plot.'

[raster, mapOfOddsJoint]=Rasterize(deltaFoF, sigma, movements, mapOfOdds, xev, yev, params);

%% 'Step 3.3: Saving and quitting.'

output_args.raster = raster;
output_args.params = params;
output_args.deltaFoF = deltaFoF;
output_args.deletedCells = [];
output_args.movements = movements;

output_args.mu = mu;
output_args.sigma = sigma;

output_args.imageAvg = NaN;
output_args.F0 = NaN;

output_args.dataAllCells = NaN;

end