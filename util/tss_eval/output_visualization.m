function output_visualization(desDir, flow1, mask1, im1, im2, suffix, maxmotion, bgcolor, flbgcolor)
    
if ~isempty(mask1)
    foreground1 = set_to_with_mask(im1, bgcolor, ~mask1);
    imwrite(foreground1, sprintf('%s/foreground%s.png', desDir, suffix));
else
    mask1 = true([size(im1, 1), size(im1, 2)]);
end

if ~isempty(flow1)
    [warped1, validMask] = warp_image(im2double(im2),flow1(:,:,1),flow1(:,:,2),mask1);
    warped1 = set_to_with_mask(warped1, bgcolor, ~mask1 | ~validMask);

    [flowmap1, unknown] = flowToColor(flow1, maxmotion);
    flowmap1 = set_to_with_mask(im2double(flowmap1), flbgcolor, ~mask1 | unknown);

    imwrite(warped1, sprintf('%s/warped%s.png', desDir, suffix));
    imwrite(flowmap1, sprintf('%s/flow%s.png', desDir, suffix));
end

end