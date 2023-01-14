imdata = cast(rgb2gray( imread('Space-Station-Cargo-Launch.jpeg')), "double");
imdata = imresize(imdata, [350 350]);

% Sharp line
%imdata = imdata(141:240, 41:140);
% Shadow
%imdata = imdata(121:220, 101:200);

%%% Parameters %%%
s = size(imdata);
disp(s)


h = s(1);
w = s(2);
sig = 3.5;


%%% Parameters %%%
% Epsilon for zero division
eps = 0.00001;
% FP, CG convergence criterions
max_diff_FP = 0.01;
max_diff_FP_u = 0.01;
max_diff_CG = 0.01;
max_diff_rof = 0.01;
% Initial guess for k
init_k = Gauss_2D(h, w, 5);
% Lambdas
lambda_k = 0.1;
lambda_u = 0.1;
lambda_tvrof = 0.1;
% del t for tvrof
denoise_del_t  = 0.001;
%%%%%%

% Make og_kernel
og_kernel = Gauss_2D(h, w, sig);
figure('name',"og kernel");
surf(og_kernel);
% Normalize
og_kernel = normalize_2d(og_kernel);

% original crip image
u_og = normalize_2d(imdata);
figure('name',"og image");
heatmap(u_og);
colormap(gray);
grid off



% Convolve crisp image with gaussian kernel
a = fftshift(ifft2(fft2(u_og).*fft2(og_kernel)));
u0 = normalize_2d(reshape(a, [h, w]));
figure('name',"og image convolved with og kernel");
heatmap(u0);
colormap(gray);
grid off

% Shock filter on u0
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


% Denoise k
disp("Denoise shock-filtered solution")
sol_k = reshape(denoise(sol_k, lambda_tvrof, denoise_del_t, eps, max_diff_rof), [h, w]);
disp(" ")
figure('name',"Denoise shock filtered kernel solution (TVROF)");
surf(sol_k);

%{
% Cutoff solution
cutoff = (max(sol_k,[],'all') + min(sol_k,[],'all'))*(1/2);
sol_k(sol_k < cutoff) = 0;
figure('name',"cutoff olution");
surf(sol_k);
%}

%Convolve original image with found k 
b = normalize_2d(fftshift(ifft2(fft2(u_og).*fft2(sol_k))));
figure('name',"Convolve og image with shock filter + denoised k");
heatmap(real(b));
colormap(gray);
grid off

% Get u
disp("Euler-Lagrange solving for u")
sol_u = reshape(get_u(ur, u0, sol_k, lambda_u, eps, max_diff_FP_u, max_diff_CG), [h, w]);
disp(" ");
figure('name',"image Euler-Lagrange solution (p=2)");
heatmap(sol_u);
colormap(gray);
grid off

%Convolve found u with found k 
c = normalize_2d(fftshift(ifft2(fft2(sol_u).*fft2(sol_k))));
figure('name',"Convolve solution u with shock filter + denoised k");
heatmap(real(c));
colormap(gray);
grid off
