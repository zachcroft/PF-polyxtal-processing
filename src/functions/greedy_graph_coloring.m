% This function takes an adjacency matrix and colors a graph
function op_mapping = greedy_graph_coloring(adjacency_matrix)
    num_nodes = size(adjacency_matrix, 1);
    op_mapping = zeros(num_nodes, 1);
    
    for node = 1:num_nodes
        % Get neighboring nodes
        neighbors = find(adjacency_matrix(node, :));
        
        % Get colors of neighboring nodes
        neighboring_colors = op_mapping(neighbors);
        
        % Find the smallest unused color
        unused_color = 1;
        while any(neighboring_colors == unused_color)
            unused_color = unused_color + 1;
        end
        
        % Assign the color to the current node
        op_mapping(node) = unused_color;
    end
end