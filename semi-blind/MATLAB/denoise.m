function out = denoise(img, lamb, del_t, eps, max_diff_rof)
    img_size = size(img);

    M = img_size(1);
    N = img_size(2);
    
    % set u
    u = img;
    max_difference_rof = 100;
    while max_difference_rof > max_diff_rof
        % Boundary conditions
        u(:, 1) = u(:, 2);
        u(:, N) = u(:, N-1);
        u(1, :) = u(2, :);
        u(M, :) = u(M-1, :);

        ux_f = forward_x_derivative(u);
        uy_f = forward_y_derivative(u);
        ux_b = backward_x_derivative(u);
        uy_b = backward_y_derivative(u);


        % Derivative of TV w.r.t. ux and uy, respectively.
        TV_ux_f = ux_f ./ sqrt(eps + ux_f.^2 + m(uy_f, uy_b).^2);
        TV_uy_f = uy_f ./ sqrt(eps + uy_f.^2 + m(ux_f, ux_b).^2);

        % Derivative of derivative of TV w.r.t. ux w.r.t. x
        TV_ux_f_x_b = backward_x_derivative(TV_ux_f);
        % Derivative of derivative of TV w.r.t. uy w.r.t. y
        TV_uy_f_y_b = backward_y_derivative(TV_uy_f);

        % Get next u
        next_u = u + del_t.*(TV_ux_f_x_b + TV_uy_f_y_b - lamb*(u - img));

        % Update max difference
        max_difference_rof = max(abs(next_u - u), [], "all");

        % Update u 
        u = next_u;
        

    end

    out = normalize_2d(u);
