function out = conv2Dfft(a, b)
    out = fftshift(ifft2(fft2(a) .* fft2(b)));
end