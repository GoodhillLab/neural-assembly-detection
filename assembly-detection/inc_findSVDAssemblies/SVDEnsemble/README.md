# SVDEnsemble
==============

by Shuting Han, Feb. 2018

Overview
--------
This is the code for defining neuronal ensembles using singular value decomposition (SVD). Conceptually, we view neuronal ensembles as representative population vectors in N-dimensional space, where N is the number of neurons. SVD is used to find such representative states, and the member neurons therein.

The SVD method consists of the following steps:
1. Defining high activity frames;
2. TF-IDF normalization;
3. Generating binarized similarity matrix;
4. SVD;
5. Defining important neurons in each significant SVD state.

This repo is based on Luis Carrillo-Reid's Stoixeion package (forked under https://github.com/hanshuting/Stoixeion), but is made much more efficient and easier to understand.

Usage
--------
Call function `[core_svd,state_pks,param] = findSVDensemble(data,coords,param)`, and see the function for more explanations.

Reference
--------
* Carrillo-Reid, L., Miller, J. E. K., Hamm, J. P., Jackson, J., & Yuste, R. (2015). Endogenous sequential cortical activity evoked by visual stimuli. Journal of Neuroscience, 35(23), 8813-8828.
