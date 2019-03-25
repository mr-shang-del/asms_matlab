function profile = kernel_Epanechnikov(sz)
    [rs, cs] = ndgrid((1:sz(1)) - floor(sz(1)/2), (1:sz(2)) - floor(sz(2)/2));
    rs = rs/(sz(1)/2);
    cs = cs/(sz(2)/2);
    profile = 2/3.14*(1-rs.^2-cs.^2);
    profile(find(profile<0)) = 0;
end

