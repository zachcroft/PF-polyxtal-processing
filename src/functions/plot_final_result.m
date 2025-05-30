% This function plots the original grain ID map with the 
% post-smoothed grain ID map w/ correct labeling
function plot_final_result(gid_map,final_gid_map,figure_height)
    figure
    for i = 1:size(gid_map,3)
        subplot(2,1,1)
        A = squeeze(gid_map(:,:,i));
        imagesc(A); axis square;
        colorbar; colormap(jet); clim([0 max(final_gid_map,[],'all')])
        title("Original");
    
        subplot(2,1,2)
        if size(gid_map,3) == 1
          B = final_gid_map;
        else
          B = squeeze(final_gid_map(i,:,:));
        end
        imagesc(B); axis square;
        colorbar; colormap(jet); clim([0 max(final_gid_map,[],'all')])
        title("Smoothed");
        set(gcf,'Position',[100,200,figure_height*0.6,figure_height])
        drawnow;
    end
end