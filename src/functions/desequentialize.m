% This script relabels grain IDs to their original
% labels
function [final_gid_map] = desequentialize(gid_map_smooth,mapping)
    disp("Relabeling grain IDs...")
    gid_list   = unique(gid_map_smooth);
    num_grains = length(gid_list);

    disp(strcat("FINAL NUMBER OF GRAINS: ",num2str(num_grains-1)));
    
    final_gid_map = zeros(size(gid_map_smooth));
    for i = 1:num_grains
        proper_label = mapping(gid_list(i));
        grain = (gid_map_smooth == gid_list(i));
        final_gid_map = final_gid_map + proper_label.*grain;
    end
end