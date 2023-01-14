function out = vec_r(i, M)
    m_arr = 0:(M-1);
    inp = -((i)/M).*(m_arr);
    out = f(inp);
    
end