% This function calculates the phase-field mobility from
% the completeness for the HEDM reconstruction, as described
% by Equations 6-8 in the text.
function [M] = calculate_mobility_(C,a,b,M_min)
    apply_filter = false;              % Median filter for completeness
    filter_px    = 3;                 % Number of pixels for filter
    apply_mask   = false;              % Mask by the sample boundary
    
    % Smooth completeness with median filter
    if apply_filter == true
        C = medfilt2(C,[filter_px filter_px]);
    end

    phi = (b - C)./(b - a);                     % Eq. 8 in the text
    p   = (phi.^3).*(6.*phi.^2 - 15.*phi + 10); % Eq. 7 in the text

    % Eq. 6 in the text:
    M        = (1 - M_min).*p + M_min;
    M(C > b) = M_min;
    M(C < a) = 1;

    %if apply_mask == true
    %    mobility = mobility.*map_slice;
    %end

    % Display the 1D function being used:
    C_1D = linspace(0,1,100);
    phi = (b - C_1D)./(b - a);                     % Eq. 8 in the text
    p   = (phi.^3).*(6.*phi.^2 - 15.*phi + 10); % Eq. 7 in the text
    M_1D        = (1 - M_min).*p + M_min;
    M_1D(C_1D > b) = M_min;
    M_1D(C_1D < a) = 1;

    figure
    plot(C_1D,M_1D,'.-','MarkerSize',14,'linewidth',2)
    xlabel("Completeness")
    ylabel("Phase-field Mobility")
    set(gca,"FontSize",20)
    ylim([0 1])
    grid on


end
