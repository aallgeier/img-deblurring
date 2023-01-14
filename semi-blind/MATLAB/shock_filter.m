function out = shock_filter(u_init, num_iters)

    del_t = 0.3;
    u = u_init;
    
    for n = 1:num_iters

        ux_f = forward_x_derivative(u);
        ux_b = backward_x_derivative(u);

        uy_f = forward_y_derivative(u);
        uy_b = backward_y_derivative(u);

        u = u - del_t * sqrt((m(ux_f, ux_b)).^2 + (m(uy_f, uy_b)).^2) .* sign(L(u));
    end

    u = (u-min(u(:)))*(1/(max(u(:))-min(u(:))));
    out = u;