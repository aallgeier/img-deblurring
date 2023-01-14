%Here we assume that the x axis is going towards the right. 
%Thus, "forward" is toward the right.
% output_ij = A_i(j+1) - A_ij

function u_shifted_left = forward_x_derivative(u)
    u_size = size(u);

    h = u_size(1);
    w = u_size(2);

    u_shifted_left = zeros(h, w);

    u_shifted_left(:, 1:w-1) = u(:, 2:w);
    u_shifted_left(:, w) = u(:, w);

    u_shifted_left = u_shifted_left - u;
end