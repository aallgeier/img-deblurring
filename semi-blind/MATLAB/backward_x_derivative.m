function u_shifted_right = backward_x_derivative(u)
    u_size = size(u);

    h = u_size(1);
    w = u_size(2);

    u_shifted_right = zeros(h, w);
    
    u_shifted_right(:, 2:w) = u(:, 1:w-1);
    u_shifted_right(:, 1) = u(:, 1);

    u_shifted_right = u - u_shifted_right;
    
end