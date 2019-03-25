function profile_deriv = kernel_Epanechnikov_deriv(sz)
    [rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
    rs = rs/(sz(1)/2);
    cs = cs/(sz(2)/2);
    profile_deriv = zeros(sz);
    profile_deriv(find(rs.^2+cs.^2<=1)) = -2/3.14;
end

