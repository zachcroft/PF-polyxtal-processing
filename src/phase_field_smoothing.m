% This script automates the smoothing process. Set the 
% path to the .mat file and select the number of 
% smoothing iterations (nstep)
tic;

% Code Parameters
%----------------------------------------------------
nstep         = 5;     % # of smoothing steps
trim          = 0;     % Number of px to trim from end
figure_height = 1000;  % Controls the size of figures
gpu           = false; % GPU acceleration

filename = "../input_data/test_2D.mat";   % Path to .mat file
%----------------------------------------------------

addpath('functions');
load(filename);

[gid_map_seq,mapping] = sequentialize(gid_map,trim);
op_mapping            = calculate_op_assignment(gid_map_seq);
centroids             = calculate_centroids(gid_map_seq,op_mapping);
phi                   = generate_order_parameters(gid_map_seq, op_mapping);
op_map                = smoothing(phi,nstep,figure_height,gpu);
gid_map_smooth        = convert_to_gid_map(op_map,centroids,gpu);
final_gid_map         = desequentialize(gid_map_smooth,mapping);

plot_final_result(gid_map,final_gid_map,figure_height);
 
elapsedTime = toc;
disp(['Elapsed Time: ', num2str(elapsedTime/60), ' min']);
