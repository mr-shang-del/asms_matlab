function patch = crop_patch(im, pos, patch_sz)
% Utility function to crop an image patch to compute color histogram
    xs = floor(pos(2)) + (1:patch_sz(2)) - floor(patch_sz(2)/2);
	ys = floor(pos(1)) + (1:patch_sz(1)) - floor(patch_sz(1)/2);
	
	%check for out-of-bounds coordinates, and set them to the values at
	%the borders
	xs(xs < 1) = 1;
	ys(ys < 1) = 1;
	xs(xs > size(im,2)) = size(im,2);
	ys(ys > size(im,1)) = size(im,1);
    patch = im(ys,xs,:);
end

