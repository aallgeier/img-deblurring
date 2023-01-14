function out = L(u)

    ux = m(forward_x_derivative(u), backward_x_derivative(u));
    uy = m(forward_y_derivative(u), backward_y_derivative(u));
    
    uxx = m(forward_x_derivative(ux), backward_x_derivative(ux));
    uyy = m(forward_y_derivative(uy), backward_y_derivative(uy));
    
    uxy = m(forward_y_derivative(ux), backward_y_derivative(ux));

    out = (uxx .* (ux.^2)) + 2 * ((uxy .* ux) .* uy) + (uyy .* (uy.^2));

end