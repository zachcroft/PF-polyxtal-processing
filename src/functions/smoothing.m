% This script performs the smoothing via a phase-field
% method for grain growth
function [op_map] = smoothing(phi,nstep,figure_height,gpu)
    Nx     = size(phi,1);
    Ny     = size(phi,2);
    Nz     = size(phi,3);
    num_op = size(phi,4);

    if Nz > 1
      dim = 3;
    else 
      dim = 2;
    end

    % Convert to single precision
    phi     = (single(phi));
    lap_phi = (single(zeros(Nx, Ny, Nz, num_op)));
    dphidt  = (single(zeros(Nx, Ny, Nz, num_op)));
    sum_op2 = (single(zeros(Nx, Ny, Nz)));
    op_map  = (single(zeros(Nx, Ny, Nz)));

    if gpu == true
        phi     = gpuArray(phi);
        lap_phi = gpuArray(lap_phi);
        dphidt  = gpuArray(dphidt);
        sum_op2 = gpuArray(sum_op2);
        op_map  = gpuArray(op_map);
    end
    
    %=============================
    % Phase-field parameters
    W        = 1.0;   % Gradient energy coefficient
    M        = 1.0;   % Allen-Cahn mobility
    radius   = 5.0;   % Particle size
    alpha    = 1.5;
    kappa    = 0.5;
    dx       = 0.5;
    dy       = 0.5;
    dt       = 0.075;
    %=============================
    nprint         = 1; % Plotting frequency
    exterior_steps = 5; % Number of steps for smoothing exterior region

    % Calculate mobility based on completeness
    M = ones(Nx,Ny,Nz);
    %M = calculate_mobility();
    
    disp("Begin smoothing process...")
    % Smoothing w/ grain growth model
    for step = 0:nstep
        sum_op2 = sum(phi.^2, 4);
        lap_phi = calc_laplacian(phi,dx, dy,lap_phi, dim);
        dphidt = -M .* (W .* (-phi + phi.^3 + ...
                        2 .* alpha .* phi .* (sum_op2 - phi.^2)) - ...
                        kappa .* lap_phi);
        if step>exterior_steps
            dphidt(:,:,:,1) = 0.0;
        end
        phi = phi + dt .* dphidt;
    
        [~, op_map] = max(phi, [], 4);
    
        % Plotting
        if (mod(step,nprint) == 0)
            %disp(step)
    
            subplot(2,1,1)
            A = squeeze(M(100,:,:));
            imagesc(A);
            colorbar; colormap(jet); clim([0 1])
            title("Mobility");
    
            subplot(2,1,2)
            if dim == 2
              B = op_map;
            else
              B = squeeze(op_map(floor(Nx/2),:,:));
            end
            imagesc(B);
            colorbar; colormap(jet); clim([1 num_op])
            title(strcat("Step: ",num2str(step)));
            set(gcf,'Position',[100,100,figure_height*0.6,figure_height])
            drawnow;
            %print("images/step="+step,'-dpng')
        end
    end

end