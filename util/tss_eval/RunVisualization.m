%% Input parameters and files
% resultsDir :	Each subdirectory of resultsDir must contain flow1.flo,
%               flow2.flo, mask1.png and mask2.png to be evaluated.
% datasetDir :	Each subdirectory of datasetDir must contain image1.png and image2.png.
%% Output files
% warped*.png, foreground*.png, flow*.png in each subdirectory of resultsDir
%%
function RunVisualization(resultsDir, datasetDir, visSubDir, bgcolor, flbgcolor, autoFlip)
    if nargin < 3
        visSubDir = '';
    end
    if nargin < 4
        bgcolor = [0,1,1];
    end
    if nargin < 5
        flbgcolor = [0.5,0.5,0.5];
    end
    if nargin < 6
        autoFlip = false;
    end

    addpath('./flow-code-matlab');

    suffix = '';
    listing = dir(resultsDir);
    
    if ~exist('suffix', 'var') || isempty(suffix)
        suffix = '';
    end

    for i = 1:length(listing)
        listing(i).name;
        if listing(i).isdir && ~strcmp(listing(i).name, '.') && ~strcmp(listing(i).name, '..')
            desDir = sprintf('%s/%s',resultsDir, listing(i).name);
            gtDir = sprintf('%s/%s', datasetDir, listing(i).name);

            if exist(desDir, 'dir') ~= 7
                continue;
            end
            
            image1 = im2double(imread([gtDir, '/image1.png']));
            image2 = im2double(imread([gtDir, '/image2.png'])); 

            [flow1, flow2, mask1, mask2] = load_data(desDir, suffix);
            [flow1_gt, flow2_gt, mask1_gt, mask2_gt] = load_data(gtDir);

            if isempty(flow1) && isempty(flow2) && isempty(mask1) && isempty(mask2)
                continue;
            end
            
            if ~isempty(mask1) && size(mask1, 1) ~= size(image1, 1) && size(mask1, 2) ~= size(image1, 2)
                image1 = imresize(image1, size(mask1));
            elseif ~isempty(flow1) && size(flow1, 1) ~= size(image1, 1) && size(flow1, 2) ~= size(image1, 2)
                image1 = imresize(image1, [size(flow1, 1), size(flow1, 2)]);
            end
            
            if ~isempty(mask2) && size(mask2, 1) ~= size(image2, 1) && size(mask2, 2) ~= size(image2, 2)
                image2 = imresize(image2, size(mask2));
            elseif ~isempty(flow2) && size(flow2, 1) ~= size(image2, 1) && size(flow2, 2) ~= size(image2, 2)
                image2 = imresize(image2, [size(flow2, 1), size(flow2, 2)]);
            end
            
            maxmotion = -1;
            if ~isempty(flow1_gt) && ~isempty(flow2_gt) && ~isempty(flow1) && ~isempty(flow2) 
                [flow1_gt, flow2_gt] = resize_flows(flow1_gt, flow2_gt, size(flow1), size(flow2));
                maxmotion = max(computeMaxmotion(flow1_gt), computeMaxmotion(flow2_gt));
            end

            if autoFlip && ~isempty(mask1) && ~isempty(mask2) && ~isempty(mask1_gt) && ~isempty(mask2_gt) 
                mask1_gt = imresize(im2double(mask1_gt), [size(mask1, 1) size(mask1, 2)], 'bilinear') > 0.5;
                mask2_gt = imresize(im2double(mask2_gt), [size(mask2, 1) size(mask2, 2)], 'bilinear') > 0.5;
                
                FAcc1_1 = compute_scores(mask1, [], mask1_gt, [], []);
                FAcc2_1 = compute_scores(mask2, [], mask2_gt, [], []);
                FAcc1_0 = compute_scores(~mask1, [], mask1_gt, [], []);
                FAcc2_0 = compute_scores(~mask2, [], mask2_gt, [], []);
                if FAcc1_1 + FAcc2_1 < FAcc1_0 + FAcc2_0
                    mask1 = ~mask1;
                    mask2 = ~mask2;
                end
            end

            outdir = [desDir, '/', visSubDir];
            if exist(outdir, 'dir') ~= 7
                mkdir(outdir);
            end
            
            output_visualization(outdir, flow1, mask1, image1, image2, '1', maxmotion, bgcolor, flbgcolor);
            output_visualization(outdir, flow2, mask2, image2, image1, '2', maxmotion, bgcolor, flbgcolor);
        end
    end

end