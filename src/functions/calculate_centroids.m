% This script's purpose is to calculate the centroid list
% grain ID list with their centroid positions, an Nx5 vector
% where col 1 is the grain ID, col 2 is the OP ID and 
% col's 3-5 are the x,y,z coordinates for the grain centroid.
function ground_truth_centroids = calculate_centroids(array,op_mapping)
    disp("Calculating grain centroids...")
    gid_list   = unique(array);
    num_grains = length(gid_list);
    num_op     = max(op_mapping);
    
    ground_truth_centroids = zeros(num_grains,5);

    ground_truth_centroids(:,1) = gid_list;
    ground_truth_centroids(:,2) = op_mapping;

    for i = 1:num_grains
        % Step i) Extract the grain
        grain = (array == gid_list(i));

        % Step ii) Get the coordinates of the grain
        [rows, cols, pages] = ind2sub(size(grain), find(grain == 1));

        % Step iii) Avg. to get centroid coordinate
        centroid = [mean(rows), mean(cols), mean(pages)];

        % Step iv) Append the centroid to the list
        ground_truth_centroids(i,3) = centroid(1);
        ground_truth_centroids(i,4) = centroid(2);
        ground_truth_centroids(i,5) = centroid(3);
    end
end