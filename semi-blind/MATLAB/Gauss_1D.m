function out = Gauss_1D(x, mu, sigma)
    out = (1./(sigma * sqrt(2*pi))) * exp((-1/2)*((x-mu).^2./sigma^2));
end