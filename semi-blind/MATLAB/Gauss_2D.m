function g = Gauss_2D(M, N, sigma)
    x_vec = Gauss_1D((0:(N-1)) - floor(N/2), 0, sigma);
    y_vec = Gauss_1D((0:(M-1)) - floor(M/2), 0, sigma);
    g = y_vec' * x_vec;
end



