imdata = cast(rgb2gray( imread('mug.png')), "double");

s = size(imdata);
disp(s)
h = s(1);
w = s(2);

%%% Parameters %%%
% Epsilon
eps = 0.00001;
% FP, CG convergence criterions
max_diff_FP = 0.01;
max_diff_CG = 0.01;
max_diff_rof = 0.01;
% Initial guess for k
init_k = Gauss_2D(h, w, 5);
% lambdas
lambda_k = 5;
lambda_u = 10;
% Denoise k
denoise_lambda = 1;
denoise_del_t  = 0.001;
%%%%%%


% original image
u0 = normalize_2d(imdata);

figure('name',"blurry image");
heatmap(u0);
grid off

% Shock filter on u0
ur = shock_filter(u0, 500);

% Solve for k 
disp("Euler-Lagrange solving for k")
sol_k = get_k(ur, u0, init_k, lambda_k, eps, max_diff_FP, max_diff_CG);
figure('name',"kernel Euler-Lagrange solution (p=2)");
surf(sol_k);

% Shock filter on solution
disp("Shock-filter on Euler-Lagrange solution")
sol_k = shock_filter(sol_k, 500);
figure('name',"Shock filter on kernel solution");
surf(sol_k);
% Normalize
sol_k = (sol_k-min(sol_k(:)))*(1/(max(sol_k(:))-min(sol_k(:))));

% Denoise k
disp("Denoise shock-filtered solution")
sol_k = reshape(denoise(sol_k, denoise_lambda, denoise_del_t, eps, max_diff_rof), [h, w]);
figure('name',"Denoise shock filtered kernel solution (TVROF)");
surf(sol_k);

% Get u
disp("Euler-Lagrange solving for u")
sol_u = reshape(get_u(ur, u0, sol_k, lambda_u, eps, max_diff_FP, max_diff_CG), [h, w]);
figure('name',"image Euler-Lagrange solution (p=2)");
heatmap(sol_u);
grid off