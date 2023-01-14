function out = normalize_2d(matrix)
    out = (matrix-min(matrix(:)))*(1/(max(matrix(:))-min(matrix(:))));
end 



