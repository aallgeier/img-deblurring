% Here we assume that the y axis is going upward. 
% Thus, forward is upward.
% output_ij = A_(i-1)j - A_ij

function u_shifted_down = forward_y_derivative(u)
    u_size = size(u);

    h = u_size(1);
    w = u_size(2);

    u_shifted_down = zeros(h, w);

    u_shifted_down(2:h, :) = u(1:h-1, :);
    u_shifted_down(1,:) = u(1, :);

    u_shifted_down = u_shifted_down - u;
end


