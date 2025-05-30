% This function segments grains from order parameters
% into a grain ID map
function [gid_map_smooth] = convert_to_gid_map(op_map,ground_truth_centroids,gpu)
    disp("Converting order parameters to grain map...")
    Nx     = size(op_map,1);
    Ny     = size(op_map,2);
    Nz     = size(op_map,3);
    
    % Allocate the ground truth map
    ground_truth_map = zeros(Nx,Ny,Nz);
    
    % Open an OP_map
    n = gather(op_map);
    if gpu == true
        n = gather(op_map);
    end
    
    num_OPs = length(unique(n));
    
    % Convert to gpuArray
    if gpu == true
        ground_truth_map = gpuArray(ground_truth_map);
        ground_truth_centroids = gpuArray(ground_truth_centroids);
    end
    % Extract the order parameter
    for op_ID = 1:num_OPs
        %disp(op_ID)
    
        op = (n == op_ID);
        
        % Use bwlabel to convert label the grains within the OP
        L = bwlabeln(op);
        num_grains_in_op = length(unique(L)) - 1; % Minus 1 to exclude zero
    
        % Convert to GPU array
        if gpu == true
            L = gpuArray(L);
            num_grains_in_op = gpuArray(num_grains_in_op);
            op_ID = gpuArray(op_ID);
        end

        % Find the centroid position for a grain and determine its groundtruth ID
        for GID = 1:num_grains_in_op
        
            % Step i) Extract the grain
            grain = (L == GID);
                
            % Step ii) Get the coordinates of the grain
            [rows, cols, pages] = ind2sub(size(grain), find(grain == 1));
            
            % Step iii) Avg. to get centroid coordinate
            centroid = [mean(rows), mean(cols), mean(pages)];
            
            % == Compare the centroid for this grain to the centroids
            % for other grains in this OP ==
            
            % Find the indices for rows to this OP
            row_id = find(ground_truth_centroids(:,2) == op_ID);
            
            % Loop over these rows (grains) and calculate the centroid dist.
            min_dist    = 99999;  
            closest_gid = 0;
            for i = 1:length(row_id)
            
                % Extract the centroid from the list
                centroid_gt = ground_truth_centroids(row_id(i), 3:5);
            
                % Calculate the distance to the centroid
                dist = norm(centroid_gt - centroid);
            
                % Keep track of the GID for closest centroid
                if dist <= min_dist
                    min_dist = dist;
                    closest_gid = ground_truth_centroids(row_id(i), 1);
                end
            end
            
            % Add this grain w/ the correct label to the ground truth map
            ground_truth_map = ground_truth_map + closest_gid.*grain;
        
        end
    
    end
    
    gid_map_smooth = ground_truth_map;
    if gpu == true
        gid_map_smooth = gather(ground_truth_map);
    end
end