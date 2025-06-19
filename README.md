# PF-polyxtal-processing
A MATLAB code for post-processing HEDM reconstructions of polycrystalline microstructures. 

Based on the paper [Enhancing polycrystalline-microstructure reconstruction from X-ray diffraction microscopy with phase-field post-processing](https://www.sciencedirect.com/science/article/pii/S135964622400263X).

## Running the code
The code requires 2 inputs:
1) A grain ID map
2) A completeness/confidence map

The input data is expected to be in the format of a .mat file and placed in the /input_data/ directory. 

The main code is /src/phase_field_smoothing.m and has the following parameters:
- nstep: the number of iterations for the phase-field processing
- M_min: the minimum phase-field mobility
- a: the lower completeness threshold below which the mobility will be at a maximum
- b: the upper completeness threshold above which the mobility will be at a minimum
- gpu: a flag for using GPU acceleration

After execution the user will have access to the post-processed grain ID map as well as the order parameters.
