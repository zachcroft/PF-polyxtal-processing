% This script automates the smoothing process. Set the 
% path to the .mat file and select the number of 
% smoothing iterations (nstep)
tic;

% Code Parameters
%----------------------------------------------------
nstep         = 50;     % # of smoothing steps

a             = 0.5;   % Lower completeness threshold
b             = 0.8;   % Upper completeness threshold
M_min         = 0.12;  % Minimum mobility

figure_height = 600;   % Controls the size of figures
gpu           = false; % GPU acceleration

grain_ID_file     = "../input_data/gid_map_2D.mat";      % Path to grain ID .mat file
completeness_file = "../input_data/completeness_2D.mat"; % Path to completeness .mat file
%----------------------------------------------------
addpath('functions');
load(grain_ID_file);
load(completeness_file)

[gid_map_seq,mapping] = sequentialize(gid_map);
op_mapping            = calculate_op_assignment(gid_map_seq);
centroids             = calculate_centroids(gid_map_seq,op_mapping);
phi                   = generate_order_parameters(gid_map_seq, op_mapping);
M                     = calculate_mobility(C,a,b,M_min);
op_map                = smoothing(phi,M,nstep,figure_height,gpu);
gid_map_smooth        = convert_to_gid_map(op_map,centroids,gpu);
final_gid_map         = desequentialize(gid_map_smooth,mapping);

plot_final_result(gid_map,final_gid_map,figure_height);
 
elapsedTime = toc;
disp(['Elapsed Time: ', num2str(elapsedTime/60), ' min']);
