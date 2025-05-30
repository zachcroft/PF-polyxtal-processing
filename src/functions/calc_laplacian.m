% **********************************************************************
% A vectorized function for calculating the laplacian for all
% slices of the 3D array.
function laplace = calc_laplacian(phi, dx, dy, laplace, dim)
    phi_up = circshift(phi, [-1, 0, 0]);
    phi_down = circshift(phi, [1, 0, 0]);
    phi_left = circshift(phi, [0, -1, 0]);
    phi_right = circshift(phi, [0, 1, 0]);
    phi_forw = circshift(phi, [0, 0, -1]);
    phi_back = circshift(phi, [0, 0, 1]);
    laplace = (phi_up + phi_down + phi_left + phi_right + phi_forw + phi_back - 2*dim * phi) / (dx * dy);
end