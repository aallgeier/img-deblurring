function u_shifted_up = backward_y_derivative(u)
    u_size = size(u);

    h = u_size(1);
    w = u_size(2);

    u_shifted_up = zeros(h, w);

    u_shifted_up(1:h-1, :) = u(2:h, :);
    u_shifted_up(h, :) = u(h, :);

    u_shifted_up = u - u_shifted_up;

end

