function Dx = Dx_minus(M, N)

num = (M*N - M)*2;
sparse_i = zeros(1, num);
sparse_j = zeros(1, num);
sparse_v = zeros(1, num);

k = 1;

    for l=0:(M*N-1)
        Q = floor(l / N);
        R = l - N*Q;
        
        if not(R == 0)
            % Dx(l+1, l+1) = 1;
            sparse_i(k) = l+1;
            sparse_j(k) = l+1;
            sparse_v(k) = 1;
            k = k+1;

            % Dx(l+1, l) = -1;
            sparse_i(k) = l+1;
            sparse_j(k) = l;
            sparse_v(k) = -1;
            k = k+1;

        end
    end

Dx = sparse(sparse_i,sparse_j,sparse_v, M*N, M*N);
end