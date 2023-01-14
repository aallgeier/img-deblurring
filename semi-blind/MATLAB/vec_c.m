function out = vec_c(j, N)
    n_arr = 0:(N-1);
    inp = -((j)/N)*(n_arr);
    out = f(inp);
end