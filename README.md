## Project Name 
Classical Image Deblurring and Denoising Methods

## Summary
Implemented in MATLAB algorithms provided in the following papers: <br>
**(tvrof)** Leonid I. Rudin, Stanley Osher, Emad Fatemi, Nonlinear total variation based noise removal algorithms, 1992<br>
**(shock filter)** Stanley Osher and Leonid I. Rudin, Feature-Oriented Image Enhancement Using Shock Filters, 1990<br>
**(semi-blind)** James H. Money, Sung Ha Kang, Total Variation Semi-Blind Deconvolution Using Shock Filters, 2006


## Generated images
### tvrof
Denoising by minimizing the total variation of an image.
<p float="left">
  <img src="generated images/tvrof/tvrof-noisy.png" width="250" />
  <img src="generated images/tvrof/tvrof-denoised.png" width="250" /> 
</p>

### shock filter 
Enhancing edges.
<p float="left">
  <img src="generated images/shock filter/shockfilter-blurry.png" width="250" />
  <img src="generated images/shock filter/shockfilter-shocked.png" width="250" /> 
</p>

### semi-blind
Solving Euler-Lagrange equiations to find the blur kernel and the crisp image by the Lagged Diffusivity Fixed Point Method with a shock filtered image as the initial input and the conjugate gradient method.
<p float="left">
  <img src="generated images/semi-blind/semi-blind-blurry-image.png" width="250" />
  <img src="generated images/semi-blind/semi-blind-image-solution.png" width="250" /> 
</p>