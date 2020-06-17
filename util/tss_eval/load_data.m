function [flow1, flow2, mask1, mask2, file1, file2] = load_data(srcDir, suffix)
    if nargin < 2
        suffix = '';
    end

    try
        mask1 = imread(sprintf('%s/mask1%s.png', srcDir, suffix));
        mask2 = imread(sprintf('%s/mask2%s.png', srcDir, suffix));
    catch
        mask1 = [];
        mask2 = [];
    end

    try
        flow1 = readFlowFile(sprintf('%s/flow1%s.flo', srcDir, suffix));
        flow2 = readFlowFile(sprintf('%s/flow2%s.flo', srcDir, suffix));
    catch
        flow1 = [];
        flow2 = [];
    end

    try
        table = readtable(sprintf('%s/pair.txt', srcDir));
        namepairs = table{:, {'Image1','Image2'}};

        file1 = namepairs{1,1};
        file2 = namepairs{1,2};
    catch
        file1 = '';
        file2 = '';
    end
end