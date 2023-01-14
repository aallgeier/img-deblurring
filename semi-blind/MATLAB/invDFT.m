function out = invDFT(inp)
    s = size(inp);
    M = s(1);
    N = s(2);

    inv_F_row = zeros(1, M * N);
    out = zeros(M * N, 1);

    for l = 0:(M*N-1)
        Q = floor(l/N);
        R = l - Q*N;

        rQ_prime = vec_r_prime(Q, M);
        cR_prime = vec_c_prime(R, N);

        for s = 0:M-1
            inv_F_row(s*N+1:(s+1)*N) = (1/(M * N)) * rQ_prime(s+1) * cR_prime;
        end

        out(l+1) = inv_F_row @ inp;
        
    end
end