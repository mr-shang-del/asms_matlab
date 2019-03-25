function [precision, fps] = run_tracker(video, show_visualization)

	%path to the videos (you'll be able to choose one with the GUI).
	base_path = 'D:\JiangShan\data_seq\otb100\Benchmark';

	%default settings
	if nargin < 1, video = 'choose'; end
	if nargin < 4, show_visualization = 1; end
    
    if strcmp(video, 'choose')
        video = choose_video(base_path);
    end
    
    [img_files, pos, target_sz, ground_truth, video_path] = load_video_info(base_path, video);

	%call tracker function with all the relevant parameters
	[positions, time] = tracker(video_path, img_files, pos, target_sz, show_visualization);
			
	%calculate and show precision plot, as well as frames-per-secon
    precisions = precision_plot(positions, ground_truth, video, 1);
	fps = numel(img_files) / time;

    fprintf('%12s - Precision (20px):% 1.3f, FPS:% 4.2f\n', video, precisions(20), fps);

end
