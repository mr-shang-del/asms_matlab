function w = weight_image( table, img )
    img = single(img);
    [h, w, d] = size(img);
    if d==3
        r = img(:,:,1);
        g = img(:,:,2);
        b = img(:,:,3);
        indexIM = 1+floor(r(:)/16)+floor(g(:)/16)*16+floor(b(:)/16)*16*16;
        
        w = reshape(table(indexIM), h, w);
    else
        indexIM = 1+floor(img(:)/16);
        w = reshape(table(indexIM), h, w);
    end

end

