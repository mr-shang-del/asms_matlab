function [positions, rects, time] = tracker(video_path, img_files, pos, target_sz, ...
        show_visualization)
    bound1 = 0.05;
    bound2 = 0.1;
    target_sz0 = target_sz;

    time = 0;  %to calculate FPS
    rects = zeros(numel(img_files), 4);
	positions = zeros(numel(img_files), 2);  %to calculate precision1

	for frame = 1:numel(img_files),
		%load image
		im = imread([video_path img_files{frame}]);

		tic();
        if frame>1
            check = 0;
            [pos, scale] = my_mean_shift(im, pos, target_sz, q_hist, b_hist, wAvgBg, bound1, bound2);
            target_sz_new = 0.7*target_sz + 0.3*target_sz*scale;
            
            if abs(log(scale))>0.05
                [~, scale_back] = my_mean_shift(im_old, pos, target_sz_new, q_hist, b_hist, wAvgBg, bound1, bound2);
                if abs(log(scale*scale_back))>0.1
                    alpha = 0.1*target_sz0(1)/target_sz(1);
                    target_sz = (0.9-alpha)*target_sz+0.1*target_sz*scale+alpha*target_sz0;
                    check = 1;
                end
            end
            
            if ~check
                target_sz = target_sz_new;
            end
            im_old = im;    
        end        
        
        if frame == 1
            %Initialize target model
            target_patch = crop_patch(im, pos, target_sz);
            background_patch = crop_patch(im, pos, floor(1.5*target_sz));
            q_hist = color_histogram(target_patch, 1);
            b_hist = color_histogram(background_patch, 0);
            wbi = sqrt(b_hist ./ q_hist);
            Sbg = sum(q_hist(find(wbi>1)));
            Sfg = sum(q_hist);
            wAvgBg = max(0.1, min(Sfg/Sbg, 0.5));
            im_old = im;
        end
		
        time = time + toc;
        rects(frame,:) = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
        positions(frame,:) = pos;
        
        if show_visualization == 1
            rect_position = rects(frame,:);
            if frame == 1,  %first frame, create GUI
                figure('Name',['Tracker - ' video_path]);
                im_handle = imshow(uint8(im), 'Border','tight', 'InitialMag', 100 + 100 * (length(im) < 500));
                rect_handle = rectangle('Position',rect_position, 'EdgeColor','g');
                text_handle = text(10, 10, int2str(frame));
                set(text_handle, 'color', [0 1 1]);
            else
                try  %subsequent frames, update GUI
                    set(im_handle, 'CData', im)
                    set(rect_handle, 'Position', rect_position)
                    set(text_handle, 'string', int2str(frame));
                catch
                    return
                end
            end

            drawnow
    %         pause
        end
        
    end
end

