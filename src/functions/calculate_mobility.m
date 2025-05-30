%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        create_mobility.m                              %
%                                                                       %
%  Used for generating phase field mobility from the completeness map.  %
%                                                                       %
%                 Created by Zach Croft, 12/2/2023                      %
%                                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [mobility] = calculate_mobility()
% ===== Parameters =====

load_data    = true;             % Load completeness data
slice        = 75;                % Vertical 2D slice of data
apply_filter = false;              % Median filter for completeness
filter_px    = 3;                 % Number of pixels for filter
expression   = 'interpolation';       % Set the mobility expression
apply_bounds = true;              % e.g. M=0 if C<0.5, M=1 if C>0.8
min_mobility = 0.05;              % Changes lower bound (to smooth GBs)
apply_mask   = false;              % Mask by the sample boundary
cmap         = 'jet';             % Colormap for plotting
save_to_mat  = false;             % Save mobility to .mat
fontsize     = 20;                % Font size for plot



% ===== Main code =====

% Load the completeness data
if load_data == true
    load('DCT_Base_1.mat')
end


% Extract the 3D data arrays
[x, y, z] = meshgrid(size(gid_map,1), size(gid_map,2), size(gid_map,3));
c = comp;

% Smooth completeness with median filter
if apply_filter == true
    c = medfilt2(c,[filter_px filter_px]);
end

% ============= Mobility expressions ==============
if strcmp(expression, 'interpolation')
    A = 0.5;
    B = 3.33;
    mobility = -((B.*(c-0.5)).^3).*(6.*(B.*(c-0.5)).^2 - 15.*(B.*(c-0.5)) + 10) + 1;
elseif strcmp(expression, 'exponential')
    A = 20;
    B = 0.5;
    mobility = exp(-A.*(c-B));
elseif strcmp(expression, 'linear')
    A = -3.333333;
    B = 0.8;
    mobility = A.*(c-B);
elseif strcmp(expression, 'invMinus1')
    mobility = (1./c - 1);
elseif strcmp(expression, 'none')
    mobility = c;
end


% ========== Apply boundaries and Mask ===========
if apply_bounds == true
    mobility(mobility>0.8) = 1;
    mobility(mobility<0.2) = min_mobility;
end

if apply_mask == true
    mobility = mobility.*map_slice;
end

% % =========== Plotting ============
% A = squeeze(comp(slice,:,:));
% B = squeeze(mobility(slice,:,:));
% 
% subplot(1,2,1)
% imagesc(A');
% colormap(cmap); colorbar;
% 
% subplot(1,2,2)
% imagesc(B');
% colormap(cmap); colorbar;
% set(gca, 'FontSize', fontsize);
% %caxis([0, 1])
% 
% set(gcf, 'Position', [150 100 1600 800]);
% title(['Slice at y = ' num2str(slice)]);

end
