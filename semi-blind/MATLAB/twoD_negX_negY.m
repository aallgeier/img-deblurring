function out = twoD_negX_negY(v)
     v_size = size(v);

     M = v_size(1);
     N = v_size(2);

    v_Y_reverse = zeros(M, N);
    for i=0:(M-1)
        v_Y_reverse(i+1, :) = v((M-1) - i+1, :);
    end
        
    v_X_Y_reverse = zeros(M, N);
    for j=0:(N-1)
        v_X_Y_reverse(:, j+1) = v_Y_reverse(:, (N-1) - j+1);
    end

    out = v_X_Y_reverse;
end
