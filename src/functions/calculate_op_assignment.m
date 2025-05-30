% This function takes a grain ID map and calculates a mapping
% from grain IDs to order parameters
function [op_mapping] = calculate_op_assignment(array)
    disp("Assigning grains to order parameters...")
    Nx = size(array,1);
    Ny = size(array,2);
    Nz = size(array,3);

    % Get list of grain IDs
    gid_list = unique(array);
    %gid_list = gid_list(2:end);  % If 0 is in the list (unindexed region)
    
    XD = 5; % exclusion distance
    adjacency_matrix = zeros(length(gid_list));
    
    % Pick a GID
    for N = 2:length(gid_list)
        %disp(N)
        % Get list of coords this GID occupies
        [ind_x, ind_y, ind_z] = ind2sub(size(array), find(array == gid_list(N)));
        
        % Get minimum and maximum indices for each direction
        min_index_x = min(ind_x);
        max_index_x = max(ind_x);
        
        min_index_y = min(ind_y);
        max_index_y = max(ind_y);
        
        min_index_z = min(ind_z);
        max_index_z = max(ind_z);
        
        B = array(max(1,min_index_x - (XD+3)):min(Nx,max_index_x + (XD+3)), ...
                      max(1,min_index_y - (XD+3)):min(Ny,max_index_y + (XD+3)), ...
                      max(1,min_index_z - (XD+3)):min(Nz,max_index_z + (XD+3)));
        
        % Get list of grains within this subvolume
        gid_list_subV = unique(B);
        
        % Extract the grain
        C = (B == gid_list(N));
    
        % Dilate the grain by XD pixels
        dist = bwdist(C);
        D = zeros(size(C));
        D(dist<XD) = 1;
        
        % Add the dilated grain to the subvolume
        E = D.*B;
        
        % Subtract
        overlap_list = unique(E);
        overlap_list = overlap_list(2:end);
        
        % Use the overlap list to update the adjacency matrix
        for i = 1:size(overlap_list,1)
            adjacency_matrix(1,find(gid_list == overlap_list(i))) = 1; % Include this line for an outerregion=1
            adjacency_matrix(N,find(gid_list == overlap_list(i))) = 1;
        end
        adjacency_matrix(N,1) = 1; % Include this line for an outerregion=1
    
    end 
    adjacency_matrix(1,1) = 1;
    
    % === APPLY GREEDY COLORING ALGORITHM ===
    op_mapping = greedy_graph_coloring(adjacency_matrix);
    num_op      = max(op_mapping);
    disp(['NUMBER OF ORDER PARAMETERS: ',num2str(num_op)])
end