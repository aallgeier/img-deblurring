function out = get_k(ur, u0, init_k, lambda, eps, max_diff_FP, max_diff_CG)
    img_size = size(u0);

    M = img_size(1);
    N = img_size(2);
    
    % 180 rotation of ur
    ur_rev = rot90(ur, 2);
    
    % B is matrix version of b in Ax = b
    B = conv2Dfft(ur_rev, u0);
    
    % Set kn and normalize
    kn = normalize_2d(init_k);
    max_difference_FP = 100;
    while max_difference_FP > max_diff_FP
        
        % Get gradient magnitude of kn
        [kn_x,kn_y] = gradient(kn);
        Dkn_mag = sqrt(kn_x.^2 + kn_y.^2 + eps);

        % Conjugate gradient descent for finding k_n+1
        ki_2d = kn;
        ri_2d = zeros(size(u0));
        di_2d = zeros(size(u0));
        max_difference_CG = 100;
        count = 1;
        while max_difference_CG > max_diff_CG
            % [ki_1,ki_2] = [ki_x,ki_y] = imgradientxy(ki_2d);
            [ki_1,ki_2] = gradient(ki_2d);
            % Devide by magnitude
            ki_1 = ki_1 ./ Dkn_mag;
            ki_2 = ki_2 ./ Dkn_mag;
            % Obtain divergence
            [ki_1x,ki_1y] = gradient(ki_1);
            [ki_2x,ki_2y] = gradient(ki_2);
            div_k = ki_1x + ki_2y;

            Aki = conv2Dfft(ur_rev, conv2Dfft(ur, ki_2d)) -  lambda * div_k;

            if count == 1
                ri_2d = B - Aki;
                di_2d = ri_2d;
                count = count + 1;
            end

            % [ki_1,ki_2] = [ki_x,ki_y] = imgradientxy(ki_2d);
            [di_1,di_2] = gradient(di_2d);
            % Devide by magnitude
            di_1 = di_1 ./ Dkn_mag;
            di_2 = di_2 ./ Dkn_mag;
            % Obtain divergence
            [di_1x,di_1y] = gradient(di_1);
            [di_2x,di_2y] = gradient(di_2);
            div_d = di_1x + di_2y;

            
            Adi = conv2Dfft(ur_rev, conv2Dfft(ur, di_2d)) -  lambda * div_d;

            alpha = sum(ri_2d .* ri_2d, "all")/sum(di_2d .* Adi, "all");

            %%% Conjugate gradient step %%%
            ki_2d_next = ki_2d + alpha*di_2d;
            % Get max difference to check convergence later
            max_difference_CG = max(abs(ki_2d_next - ki_2d), [], "all");
            % Update ki_2d
            ki_2d = ki_2d_next;

            ri_2d_next = ri_2d - alpha*di_2d;

            beta = sum(ri_2d_next .* ri_2d_next, "all")/sum(ri_2d .* ri_2d, "all");
            di_2d = ri_2d_next + beta * di_2d;

            % Update ri_2d
            ri_2d = ri_2d_next;
        
        end
            
        % Normalize ki_2d
        ki_2d = normalize_2d(ki_2d);

        % Compute sum of differences (+abs) for current kn and ki_2d
        max_difference_FP  = max(abs(ki_2d - kn), [], "all");

        % Update kn
        kn = ki_2d;

    end

    out = kn;

end







