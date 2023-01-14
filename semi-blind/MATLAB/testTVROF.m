u0 = zeros([100, 100]);
u0(20:80, 20:80) = 1;
figure('name',"image");
heatmap(u0);

noise = normrnd(0, 3, 100, 100);
noise = (noise-min(noise(:)))*(1/(max(noise(:))-min(noise(:))));

u = u0 + noise;

figure('name',"noisy image 3d");
surf(u);

figure('name',"noisy image 2d");
heatmap(u);

lamb = 1;
denoised = denoise(u, lamb, 0.0001, 0.000001, 0.0001);

figure('name',"denoised image 3d");
surf(denoised);

figure('name',"denoised image 2d");
heatmap(denoised);