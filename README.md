# Detecting neural assemblies in calcium imaging data

In the following, we give a brief overview over the main functions of the repository, to generate datasets of surrogate calcium imaging data and to analyse such datasets for assembly activity.
Some of functions for preprocessing of the datasets as well as most of the algorithms have been developed by other authors. Therefore, wherever third-party code was used, the corresponding functions can be found in a separate directory together with a README file which specifies the origin of these functions together with a list of functions which have been changed from the original. Within the functions, these changes were consistently marked with the string '`% #`'.

A complete list of third-party packages of functions is a follows in the order in which they are used:

* 'fitF0smoother' package by K. Podgorski, included with permission
* ['KalmanAll'](https://www.cs.ubc.ca/~murphyk/Software/index.html) package by K. Murphy (distributed with the 'fitF0smoother' package), included with permission
* ['peakfinder'](https://au.mathworks.com/matlabcentral/fileexchange/25500) package by N. C. Yoder, published under the FreeBSD License
* ['oopsi'](https://github.com/jovo/oopsi) package by J. Vogelstein, published under the Apache License 2.0
* ['Toolbox-Romano-et-al'](https://github.com/zebrain-lab/Toolbox-Romano-et-al) package by S. Romano et al., published under the GNU General Public License v3.0
* 'toolbox' package by V. Lopes-dos-Santos, included with permission
* ['SVDEnsemble'](https://github.com/hanshuting/SVDEnsemble) package by S. Han, published under the GNU General Public License v3.0
* ['PyFIM'](http://www.borgelt.net/pyfim.html) \& ['psf+psr'](http://www.borgelt.net/pycoco.html) package by C. Borgelt, published under the MIT License


**Reference:** J. Mölter, L. Avitan, G. J. Goodhill 2018 *submitted to BMC Biology*

*Version:* 15. October 2018


## Simulation of population calcium fluorescence activity
```Matlab
ARTIFICIAL_CALCIUM_FLUORESCENCE_GENERATION( '~/' , 'TEST_1' , 0 , 1800 , 0.5 , 'HEX5_K5_medium' , 1 , 1 , 0.01 , 6 , 0 , Inf )
```

*Prerequisits of third-party packages:* 'fitF0smoother', 'KalmanAll'

Output: `*_CALCIUM-FLUORESCENCE.mat`

* `calcium_fluorescence.F`: raw fluorescence signal [T × N matrix]
* `calcium_fluorescence.F0`: baseline fluorescence signal [T × N matrix]
* **`calcium_fluorescence.dF_F`: fluorescence signal (ΔF/F) [T × N matrix]**
* `topology`: neuron coordinates [N × 1 cell : 1 × d matrix]
* **`parameter.units`: number of neurons**
* **`parameter.dT_step`: temporal resolution / lenght of a time step (s)**
* **`parameter.time_steps`: number of time steps**
* `parameter.assembly_configuration`: underlying ground truth assembly configuration
* `parameter.rate_range`: background firing rate range
* `parameter.event`: background firing rate range
* `parameter.eventFreq`: event frequency (1/s)
* `parameter.eventMult`: event firing rate multiplier
* **`parameter.calcium_T1_2`: calcium indicator half-life (s)**
* `parameter.saturation_K`: calcium fluorescence saturation constant
* `parameter.noiseSTD`: Gaussian noise standard deviation
* `meta_information`: meta-information about the dataset -- optional


Note: For all subsequent analysis a structure as decribed above is expected for the modules to run smoothly. The minimal set of fields required is marked in bold.

## Conversion from existing calcium fluorescence activity
```Matlab
CALCIUM_FLUORESCENCE_CONVERSION( '~/Desktop/' , 'TEST_1' , dF_F_field , 0.5 , 1 )
```

Output: `*_CALCIUM-FLUORESCENCE.mat`

## Preprocessing of the calcium fluorescence activity
```Matlab
CALCIUM_FLUORESCENCE_PROCESSING( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_CALCIUM-FLUORESCENCE.mat' ] )
```

*Prerequisits of third-party packages:* 'peakfinder', 'oopsi' , 'Toolbox-Romano-et-al'

Output: `*_ACTIVITY-RASTER.mat`

* `activity_raster`: binary rastered fluorescence signal [T × N matrix]
* `activity_raster_peak_threshold`: threshold for high population fluorescence activity
* `activity_raster_peaks`: time points of high population fluorescence activity [T × 1 matrix]


Output: `*_ACTIVITY-FIM-RASTER.dat`

Output: `*_SPIKE-PROBABILITY-RASTER.mat`

* `spike_probability_raster`: binary rastered spike probabilities [T × N matrix]
* `spike_probability_raster_thresholds`: threshold for high spike probability
* `oopsi_deconvolution`: fast nonnegative matrix deconvolution (OOPSI) results


Output: `*_RASTER.mat`

* `raster`: fluorescence signal (ΔF/F) binary mask [T × N matrix]
* `params`
* `deltaFoF`: fluorescence signal (ΔF/F) [T × N matrix]
* `deletedCells`
* `movements`
* `mu`
* `sigma`
* `imageAvg`
* `F0`
* `dataAllCells`


## Detection of neural assemblies

#### Using the ICA-CS / ICA-MP algorithm
```Matlab
ICA_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_CALCIUM-FLUORESCENCE.mat' ] )
```

*Prerequisits of third-party packages:* 'toolbox'

Output: `*_ICA-ASSEMBLIES.mat`

* `cs_assembly_vectors`: assembly vectors from CS null model [1 × k cell]
* `cs_assemblies`: assemblies from CS null model [k × 1 cell]
* `ks_alpha`: KS-significance-level
* `mp_assembly_vectors`: assembly vectors from MP null model [1 × k cell]
* `mp_assemblies`: assemblies from MP null model [k × 1 cell]


#### Using the Promax-MP algorithm
```Matlab
PROMAX_MP_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_RASTER.mat' ] )
```

*Prerequisits of third-party packages:* 'Toolbox-Romano-et-al'

Output: `*_PROMAX-MP-ASSEMBLIES.mat`

* `threshSignifMatchIndex`
* `matchIndexTimeSeries`
* `assembliesCells`: assemblies [1 × k cell]
* `matchIndexTimeSeriesSignificant`
* `matchIndexTimeSeriesSignificantPeaks`
* `matchIndexTimeSeriesSignificance`
* `clustering`
* `assembliesVectors`: assembly vectors [N × k matrix]
* `PCsRot`: assembly vectors (rotated principal components) [N × k matrix]
* `confSynchBinary`
* `zMaxDensity.x`: zMax value [1 × ? matrix]
* `zMaxDensity.densityNorm`: zMax density function [1 × ? matrix]
* `zMaxDensity.normCutOff`: zMax cut-off value


#### Using the Promax-CS algorithm
```Matlab
PROMAX_CS_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_RASTER.mat' ] )
```

*Prerequisits of third-party packages:* 'toolbox', 'Toolbox-Romano-et-al'

Output: `*_PROMAX-MP-ASSEMBLIES.mat`

* `threshSignifMatchIndex`
* `matchIndexTimeSeries`
* `assembliesCells`: assemblies [1 × k cell]
* `matchIndexTimeSeriesSignificant`
* `matchIndexTimeSeriesSignificantPeaks`
* `matchIndexTimeSeriesSignificance`
* `clustering`
* `assembliesVectors`: assembly vectors [N × k matrix]
* `PCsRot`: assembly vectors (rotated principal components) [N × k matrix]
* `confSynchBinary`
* `zMaxDensity.x`: zMax value [1 × ? matrix]
* `zMaxDensity.densityNorm`: zMax density function [1 × ? matrix]
* `zMaxDensity.normCutOff`: zMax cut-off value


#### Using the CORE algorithm
```Matlab
CORE_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_SPIKE-PROBABILITY-RASTER.mat' ] )
```

Output: `*_CORE-ASSEMBLIES.mat`

* `ensemble_detection`
* `assemblies`: assemblies [1 × k cell]


#### Using the SVD algorithm
```Matlab
SVD_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_SPIKE-PROBABILITY-RASTER.mat' ] )
```

*Prerequisits of third-party packages:* 'SVDEnsemble'

Output: `*_SVD-ASSEMBLIES.mat`

* `assemblies`: assemblies [1 × k cell]
* `assemblies_activation`: assembly activation time series [T × 1 matrix]


#### Using the SGC algorithm
```Matlab
SGC_ASSEMBLY_DETECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_ACTIVITY-RASTER.mat' ] )
```

Output: `*_SGC-ASSEMBLIES.mat`

* `assembly_pattern_detection.activityPatterns`: activity patterns of high population fluorescence activity [? × 1 cell]
* `assembly_pattern_detection.patternSimilarityAnalysis.graph`: activity pattern similarity graph [1 × 1 graph]
* `assembly_pattern_detection.patternSimilarityAnalysis.communityStructure`: similarity graph community-structure analysis results
* `assembly_pattern_detection.assemblyActivityPatterns`: assembly activity patterns [k × 1 cell]
* `assembly_pattern_detection.assemblyIActivityPatterns`: activity patterns indices for every assembly activity pattern [k × 1 cell]
* `assemblies`: assemblies [k × 1 cell]


#### Using the FIM-X algorithm (Python!)
```Matlab
! $( cd ./assembly-detection/FIM_PSF_PSR_ASSEMBLY_DETECTION/ && ./py__FIM_PSF_PSR_ASSEMBLY_DETECTION.sh ~/Desktop/TEST_1/TEST_1_ACTIVITY-FIM-RASTER.dat )
```

*Prerequisits of third-party packages:* 'PyFIM', 'psf+psr'

Output: `*_FIM-PSF-PSR-ASSEMBLIES.dat`

## Collection of the results from the different algorithm for postprocessing
```Matlab
ASSEMBLIES_COLLECTION( [ '~/Desktop/' 'TEST_1' '/' 'TEST_1' '_CALCIUM-FLUORESCENCE.mat' ] )
```

Output: `*_ASSEMBLIES-COLLECTION.mat`

* `parameter`: simulation parameters
* `meta_information`: meta-information about the dataset -- optional
* `topology`: neuron coordinates [N × 1 cell : 1 × d matrix]
* `ICA_CS_assemblies`: assemblies as inferred from the ICA-CS algorithm [1 × k cell]
* `ICA_MP_assemblies`: assemblies as inferred from the ICA-MP algorithm [1 × k cell]
* `PROMAX_MP_assemblies`: assemblies as inferred from the Promax-MP algorithm [1 × k cell]
* `PROMAX_CS_assemblies`: assemblies as inferred from the Promax-CS algorithm [1 × k cell]
* `CORE_assemblies`: assemblies as inferred from the CORE algorithm [1 × k cell]
* `SVD_assemblies`: assemblies as inferred from the SVD algorithm [1 × k cell]
* `SGC_assemblies`: assemblies as inferred from the SGC algorithm [1 × k cell]
* `FIM_PSF_PSR_assemblies`: assemblies as inferred from the FIM-X algorithm [1 × k cell]
