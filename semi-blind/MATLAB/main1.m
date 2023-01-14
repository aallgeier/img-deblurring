h = 200;
w = 200;
sig = 5;

%%% Parameters %%%
% Epsilon for zero division
eps = 0.00001;
% FP, CG convergence criterions
max_diff_FP = 0.01;
max_diff_CG = 0.01;
max_diff_rof = 0.01;
% Initial guess for k
init_k = Gauss_2D(h, w, 5);
% Lambdas
lambda_k = 1;
lambda_u = 0;
lambda_tvrof = 0.1;
% del t for tvrof
denoise_del_t  = 0.001;
%%%%%%

% Make og_kernel
og_kernel = Gauss_2D(h, w, sig);
figure('name',"original kernel");
surf(og_kernel);

% original crip image
u_og = zeros(h, w);
u_og(30:170, 30:170) = 1;
%u_og(10:90, 10:40) = 1;
%u_og(30:60, 10:90) = 1;

figure('name',"original image");
heatmap(u_og);


% Convolve crisp image with gaussian kernel
a = fftshift(ifft2(fft2(u_og).*fft2(og_kernel)));
u0 = reshape(a, [h, w]);
figure('name',"blurry image");
heatmap(u0);

% Shock filter
ur = shock_filter(u0, 500);

% Solve for k 
disp("Euler-Lagrange solving for k")
sol_k = get_k(ur, u0, init_k, lambda_k, eps, max_diff_FP, max_diff_CG);
disp(" ");
figure('name',"kernel Euler-Lagrange solution (p=2)");
surf(sol_k);


% Shock filter on solution
disp("Shock-filter on Euler-Lagrange solution")
sol_k = shock_filter(sol_k, 500);
disp(" ");
figure('name',"Shock filter on kernel solution");
surf(sol_k);
% Normalize
sol_k = (sol_k-min(sol_k(:)))*(1/(max(sol_k(:))-min(sol_k(:))));


% Cutoff solution
cutoff = (max(sol_k,[],'all') + min(sol_k,[],'all'))*(1/2);
sol_k(sol_k < cutoff) = 0;
figure('name',"cutoff olution");
surf(sol_k);


% Denoise k
disp("Denoise shock-filtered solution")
sol_k = reshape(denoise(sol_k, lambda_tvrof, denoise_del_t, eps, max_diff_rof), [h, w]);
disp(" ")
figure('name',"Denoise shock filtered kernel solution (TVROF)");
surf(sol_k);


%Colvolve original image with found k 
b = fftshift(ifft2(fft2(u_og).*fft2(sol_k)));
figure('name',"convolve original image with found k");
heatmap(b);


% Get u
disp("Euler-Lagrange solving for u")
sol_u = reshape(get_u(ur, u0, sol_k, lambda_u, eps, max_diff_FP, max_diff_CG), [h, w]);
disp(" ")
figure('name',"image Euler-Lagrange solution (p=2)");
heatmap(sol_u);
grid off

