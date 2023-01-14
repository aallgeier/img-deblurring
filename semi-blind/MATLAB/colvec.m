function out = colvec(A)
    A_size = size(A);

    h = A_size(1);
    w = A_size(2);

    out = reshape(A, [1, h*w])';
end