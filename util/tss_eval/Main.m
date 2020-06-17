
DatasetRootDir = '../../dataset/tss/TSS_CVPR2016';
ResultsRootDir = '../../results/aff_tps/TSS_CVPR2016';

%% Evaluation of results.
% The output file "scores.csv" is saved as e.g. "..\Results\FG3DCar\scores.csv".
RunEvaluation([ResultsRootDir, 'FG3DCar'], [DatasetRootDir, 'FG3DCar']);
RunEvaluation([ResultsRootDir, 'PASCAL'], [DatasetRootDir, 'PASCAL']);
RunEvaluation([ResultsRootDir, 'JODS'], [DatasetRootDir, 'JODS']);

%% Visualization of results. 
% The output images are saved as e.g. "..\Results\FG3DCar\001_005\vis\*.png".
% RunVisualization([ResultsRootDir, 'FG3DCar'], [DatasetRootDir, 'FG3DCar'], 'vis');
% RunVisualization([ResultsRootDir, 'PASCAL'], [DatasetRootDir, 'PASCAL'], 'vis');
% RunVisualization([ResultsRootDir, 'JODS'], [DatasetRootDir, 'JODS'], 'vis');

% If a method does not consistently produce foreground label, use autoFlip
% option by setting the argment of autoFlip to true in RunEvaluation/RunVisualization.
% If autoFlip is on, for each image pair, it chooses either mask or ~mask
% (flipped) such that maximizes the sum of segmentation scores of the two images.
% Note that scores with this option cannot be used as official full benchmark scores.
