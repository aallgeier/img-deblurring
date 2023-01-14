function lap = get_laplacian(u)
    ux = forward_x_derivative(u);
    uxx = backward_x_derivative(ux);
    
    uy = forward_y_derivative(u);
    uyy = backward_y_derivative(uy);

    lap = uxx+uyy;
end