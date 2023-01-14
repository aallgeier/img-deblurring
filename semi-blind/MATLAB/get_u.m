function out = get_u(init_u, u0, k, lambda, eps, max_diff_FP, max_diff_CG)    
    % 180 rotation of k
    k_rev = rot90(k, 2);
    
    % B is matrix version of b in Ax = b
    B = conv2Dfft(k_rev, u0);
    
    % un
    un = init_u;
    max_difference_FP = 100;
    count_FP = 1;
    while max_difference_FP > max_diff_FP
        
        [un_x,un_y] = gradient(un);
        Dun_mag = sqrt(un_x.^2 + un_y.^2 + eps);

        % Conjugate gradient descent for finding k_n+1
        ui_2d = un;
        ri_2d = zeros(size(u0));
        di_2d = zeros(size(u0));
        max_difference_CG = 100;
        count = 1;
        while max_difference_CG > max_diff_CG
            % [ui_1,ui_2] = [ui_x,ui_y] = imgradientxy(ui_2d);
            [ui_1,ui_2] = gradient(ui_2d);
            % Devide by magnitude
            ui_1 = ui_1 ./ Dun_mag;
            ui_2 = ui_2 ./ Dun_mag;
            % Obtain divergence
            [ui_1x,ui_1y] = gradient(ui_1);
            [ui_2x,ui_2y] = gradient(ui_2);
            div_u = ui_1x + ui_2y;

            Aui = conv2Dfft(k_rev, conv2Dfft(k, ui_2d)) -  lambda * div_u;

            if count == 1
                ri_2d = B - Aui;
                di_2d = ri_2d;
                count = count + 1;
            end

            [di_1,di_2] = gradient(di_2d);
            % Devide by magnitude
            di_1 = di_1 ./ Dun_mag;
            di_2 = di_2 ./ Dun_mag;
            % Obtain divergence
            [di_1x,di_1y] = gradient(di_1);
            [di_2x,di_2y] = gradient(di_2);
            div_d = di_1x + di_2y;

            
            Adi = conv2Dfft(k_rev, conv2Dfft(k, di_2d)) -  lambda * div_d;

            alpha = sum(ri_2d .* ri_2d, "all")/sum(di_2d .* Adi, "all");

            % Conjugate gradient step
            ui_2d_next = ui_2d + alpha*di_2d;
            % Get max different for CG
            max_difference_CG = max(abs(ui_2d_next - ui_2d), [], "all");
            % Update ui_2d
            ui_2d = ui_2d_next;

            ri_2d_next = ri_2d - alpha*di_2d;

            beta = sum(ri_2d_next .* ri_2d_next, "all")/sum(ri_2d .* ri_2d, "all");
            di_2d = ri_2d_next + beta * di_2d;
            
            % Update ri_2d
            ri_2d = ri_2d_next;
        
        end
            
        % Normalize ui_2d
        ui_2d = normalize_2d(ui_2d);

        % Compute sum of differences (+abs)
        max_difference_FP = max(abs(ui_2d - un), [], "all");

        % Update un
        un = ui_2d;

    
        if rem(count_FP, 2400000)
            figure('name',"image solution");
            heatmap(un);
            colormap(gray);
            grid off
            disp("max_difference_FP")
            disp(max_difference_FP);
        end


           
        count_FP = count_FP + 1;


    end

    out = un;

end








