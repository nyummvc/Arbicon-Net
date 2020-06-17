%% Input parameters and files
% resultsDir :	Each subdirectory of resultsDir must contain flow1.flo,
%               flow2.flo, mask1.png and mask2.png to be evaluated.
% datasetDir :	Each subdirectory of datasetDir must contain flow1.flo,
%               flow2.flo, mask1.png and mask2.png as groundtruth.
%% Output file
% scores.csv in resultsDir
%%
function RunEvaluation(resultsDir, datasetDir, autoFlip)
    if nargin < 3
        autoFlip = false;
    end
    
    addpath('./flow-code-matlab');

    suffix = '';
    listing = dir(resultsDir);
    
    FAcc = [];
    SegIUR = [];
    Flip = [];
    SrcName = [];
    RefName = [];
    Name = [];

    if ~exist('suffix', 'var') || isempty(suffix)
        suffix = '';
    end
    THRESHOLDS = 1:50;

    curr = 0;
    for i = 1:length(listing)
        listing(i).name;
        if listing(i).isdir && ~strcmp(listing(i).name, '.') && ~strcmp(listing(i).name, '..')
            desDir = sprintf('%s/%s',resultsDir, listing(i).name);
            gtDir = sprintf('%s/%s', datasetDir, listing(i).name);
            
            if exist(desDir, 'dir') ~= 7
                continue;
            end
            
            flip = 0;
            fp = fopen(sprintf('%s/flip_gt.txt', gtDir), 'r');
            try
                flip = fscanf(fp, '%d');
                fclose(fp);
            catch end

            [flow1, flow2, mask1, mask2] = load_data(desDir, suffix);
            [flow1_gt, flow2_gt, mask1_gt, mask2_gt, file1, file2] = load_data(gtDir);

            if ~isempty(flow1) && ~isempty(flow2) 
                [flow1, flow2] = resize_flows(flow1, flow2, size(flow1_gt), size(flow2_gt));
            end

            if isempty(mask1) || isempty(mask2) 
                [mask1, mask2] = compute_mask_from_flows(flow1, flow2, 20);
            else
                mask1 = imresize(im2double(mask1), [size(mask1_gt, 1) size(mask1_gt, 2)], 'bilinear') > 0.5;
                mask2 = imresize(im2double(mask2), [size(mask2_gt, 1) size(mask2_gt, 2)], 'bilinear') > 0.5;
            end
            
            if autoFlip && ~isempty(mask1) && ~isempty(mask2) && ~isempty(mask1_gt) && ~isempty(mask2_gt) 
                [~, FAcc1_1] = compute_scores(mask1, [], mask1_gt, [], THRESHOLDS);
                [~, FAcc2_1] = compute_scores(mask2, [], mask2_gt, [], THRESHOLDS);
                [~, FAcc1_0] = compute_scores(~mask1, [], mask1_gt, [], THRESHOLDS);
                [~, FAcc2_0] = compute_scores(~mask2, [], mask2_gt, [], THRESHOLDS);
                if FAcc1_1 + FAcc2_1 < FAcc1_0 + FAcc2_0
                    mask1 = ~mask1;
                    mask2 = ~mask2;
                end
            end

            curr = curr + 1;
            Name{curr} = strcat(listing(i).name, '_1to2');
            SrcName{curr} = file1;
            RefName{curr} = file2;
            Flip(curr) = flip;
            thresholds = THRESHOLDS / 100 * max(size(flow2_gt, 1), size(flow2_gt, 2));
            [FAcc(curr,:),SegIUR(curr)] = compute_scores(mask1, flow1, mask1_gt, flow1_gt, thresholds);

            curr = curr + 1;
            Name{curr} = strcat(listing(i).name, '_2to1');
            SrcName{curr} = file2;
            RefName{curr} = file1;
            Flip(curr) = flip;
            thresholds = THRESHOLDS / 100 * max(size(flow1_gt, 1), size(flow1_gt, 2));
            [FAcc(curr,:),SegIUR(curr)] = compute_scores(mask2, flow2, mask2_gt, flow2_gt, thresholds);
        end
    end

    if curr > 0
        curr = curr + 1;
        SrcName{curr} = '-';
        RefName{curr} = '-';
        FAcc(curr,:) = mean(FAcc, 1);
        SegIUR(curr) = mean(SegIUR(1:curr-1));
        Flip(curr) = 1;
        Name{curr} = 'Average';

        faccs = FAcc(curr,:);
        uir = SegIUR(curr);


        curr = curr + 1;
        SrcName{curr} = '-';
        RefName{curr} = '-';
        FAcc(curr,:) = mean(FAcc(Flip == 0, :), 1);
        SegIUR(curr) = mean(SegIUR(Flip == 0));
        Flip(curr) = 0;
        Name{curr} = 'w/o flip';

        T = table(...
            SrcName', RefName', SegIUR(1:curr)',Flip(1:curr)',...
            'RowNames',Name',...
            'VariableNames',...
            {'Src'; 'Ref'; 'SegIUR'; 'Flip'});
        for t = 1:length(THRESHOLDS)
            T1 = table(FAcc(1:curr,t), 'VariableNames', {sprintf('T%d', THRESHOLDS(t))});
            T = [T T1];
        end
        T
        writetable(T, sprintf('%s/scores%s.csv', resultsDir, suffix), 'WriteRowNames',true);
    else
        disp('No result found.');
    end
end