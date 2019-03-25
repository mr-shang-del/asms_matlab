function results = run_ASMS(seq, res_path, bSaveImage)
    video_path = [];
    target_sz = seq.init_rect(1,[4,3]);
    pos = seq.init_rect(1,[2,1]) + floor(target_sz/2);
    img_files = seq.s_frames;
    
    [positions, rects, time] = tracker(video_path, img_files, pos, target_sz, show_visualization);
    
    if bSaveImage
        imwrite(frame2im(getframe(gcf)),[res_path num2str(frame) '.jpg']); 
    end
    
    fps = numel(img_files) / time;
    results.type = 'rect';
    results.res = rects;%each row is a rectangle
    results.fps = fps;
end

