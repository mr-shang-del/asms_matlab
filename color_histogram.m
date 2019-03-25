function hist = color_histogram(patch, is_foreground)
    patch = single(patch);
    [h, w, d] = size(patch);
    if is_foreground
        kernel = kernel_Epanechnikov([h,w]);
    else
        kernel = ones([h,w]);
        %ym = floor(h/2)+(-floor(target_sz(1)/2):target_sz(1)-floor(target_sz(1)/2));
        %xm = floor(w/2)+(-floor(target_sz(2)/2):target_sz(2)-floor(target_sz(2)/2));
        kernel(floor(h/6):floor(5*h/6),floor(w/6):floor(5*w/6)) = 0;
    end
    if d==3
        r = patch(:,:,1);
        g = patch(:,:,2);
        b = patch(:,:,3);
        
        indexIM = 1+floor(r(:)/16)+floor(g(:)/16)*16+floor(b(:)/16)*16*16;
        hist = accumarray(indexIM, kernel(:),[16*16*16 1])/sum(kernel(:));
    else
        indexIM = 1+floor(patch(:)/16);
        hist = accumarray(indexIM, kernel(:),[16 1])/sum(kernel(:));
    end
end

