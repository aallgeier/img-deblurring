function out = m(x, y)
    out = ((sign(x)+sign(y)) .* min(abs(x), abs(y))) / 2;
end