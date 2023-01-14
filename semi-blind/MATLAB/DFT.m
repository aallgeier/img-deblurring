function out = DFT(inp)
    s = size(inp);
    M = s(1);
    N = s(2);
    
    F_row = zeros(1, M * N);
    out = zeros(M * N, 1);
    
    for l = 0:(M*N-1)

        Q = floor(l/N);
        R = l - Q*N;
    
        rQ = vec_r(Q, M);
        cR = vec_c(R, N);
    
        for s = 0:M-1
            F_row(s*N+1:(s+1)*N) = rQ(s+1) * cR;
        end
    
        out(l+1) = F_row @ inp;
    
    end

end