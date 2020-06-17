function image = setToWithMask(image, color, mask)

nch = size(image, 3);
for i = 1:nch
    coi = image(:,:,i);
    coi(mask) = color(i);
    image(:,:,i) = coi;
end

end