function [mask1, mask2] = compute_mask_from_flows(flow1, flow2, thres)
if isempty(flow1) || isempty(flow2)
    mask1 = [];
    mask2 = [];
    return;
end
    [warpedFlow1, valid1] = warp_image(flow2, flow1(:,:,1), flow1(:,:,2));
    Confidence1 = sum(abs(flow1 + warpedFlow1).^2, 3).^0.5;
    mask1 = Confidence1 < thres;
    mask1(~valid1) = 0;

    [warpedFlow2,valid2] = warp_image(flow1, flow2(:,:,1), flow2(:,:,2));
    Confidence2 = sum(abs(flow2 + warpedFlow2).^2, 3).^0.5;
    mask2 = Confidence2 < thres;
    mask2(~valid2) = 0;
end