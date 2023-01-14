imdata = cast(rgb2gray( imread('Space-Station-Cargo-Launch.jpeg')), "double");
imdata = (imdata-min(imdata(:)))*(1/(max(imdata(:))-min(imdata(:))));

s = size(imdata);
H = s(1);
W = s(2);
sig = 2;

big_u_og = imdata;

figure('name',"original image");
heatmap(big_u_og);


big_og_kernel = Gauss_2D(H, W, sig);
figure('name',"original kernel");
surf(big_og_kernel);

big_F = DFT_matrix(H, W);
big_inv_F = inv_DFT_matrix(H, W);

a = big_inv_F*((big_F*vec(big_u_og)') .* (big_F*vec(big_og_kernel)'));
big_u0 = reshape(real(a), [H, W]);
figure('name',"blurry image");
heatmap(big_u0);



% Semi-blind on different parts of image
og_1 = big_u_og(11:60, 1:50);
u0_1 = big_u0(11:60, 1:50);

og_2 = big_u_og(71:120, 51:100);
u0_2 = big_u0(71:120, 51:100);

og_3 = big_u_og(71:120, 91:140);
u0_3 = big_u0(71:120, 91:140);

lambda_1 = 0.2;
lambda_2 = 3;
eps = 0.0001;

og_blocks = {og_1, og_2, og_3};
blurry_blocks = {u0_1, u0_2, u0_3};

for i = 1:3
    h = 50;
    w = 50;
    disp(i);

    figure('name',int2str(i)+"original image");
    heatmap(og_blocks{i});

    u0 = blurry_blocks{i};
    % Blurry image
    figure('name',int2str(i)+"-Blurry image");
    heatmap(u0);

    % Shock filter
    ur = shock_filter(u0, 500);
    figure('name',int2str(i)+"-After Shock Filter");
    surf(ur);
    
    % Initial guess for k
    init_k = Gauss_2D(h, w, 2);
    
    % Find k from blurry image
    sol_k = reshape(get_k(ur, u0, init_k, lambda_1, 3, eps), [h, w]);
    figure('name',int2str(i)+"-kernel solution (before refining)");
    surf(sol_k);
    
    % Refine k
    refined_k = reshape(denoise(sol_k, 5000, 0.1, 0.0001, 0.000001), [h, w]);
    figure('name',int2str(i)+"-refined kernel");
    surf(refined_k);
    
    % Get u
    sol_u = reshape(solve_for_u(ur, u0, refined_k, lambda_2, 20, eps), [h, w]);
    figure('name',int2str(i)+"-image solution");
    heatmap(sol_u);
end

%}