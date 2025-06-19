% This function sequentializes the grain ID labels, which is
% useful for the processing
function [gid_map_seq,gid_list] = sequentialize(gid_map)
    disp("Sequentializing grain IDs...")

    gid_map = single(gid_map);
    % Since the interior pores are labeled the same as the exterior
    % region, perform a flood fill operation to extract the exterior region
    %exterior = bwselect3(gid_map==0, 1, 1, 1);
    
    gid_list   = unique(gid_map);
    num_grains = length(gid_list);

    disp(strcat("NUMBER OF GRAINS: ",num2str(num_grains-1)));
    
    % Sequentialize the grain IDs
    gid_map_seq = zeros(size(gid_map));
    for i = 1:num_grains
      disp(i)
      grain = (gid_map == gid_list(i));
      gid_map_seq = gid_map_seq + i.*grain;
    end
    
end