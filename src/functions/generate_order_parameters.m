% This function using the order parameter assignment
% and generates the order parameters
function [phi] = generate_order_parameters(array,op_mapping)
    disp("Generating order parameters...")
    Nx = size(array,1);
    Ny = size(array,2);
    Nz = size(array,3);
    num_op   = max(op_mapping);
    gid_list = unique(array);
    phi      = zeros(Nx,Ny,Nz,num_op);
    for i = 1:num_op
        %disp(i)
        OP = zeros(Nx,Ny,Nz);
    
        % Get list of IDs for the current OP
        id_list = find(op_mapping == i);
        for j = 1:length(id_list)
            %disp(strcat(num2str(j), " out of ",num2str(length(id_list))));
            OP = OP + (array == gid_list(id_list(j)));
        end
    
        phi(:,:,:,i) = OP;
    end
end