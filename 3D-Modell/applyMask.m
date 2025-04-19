function subimage = applyMask(img, mask)
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    subimage(:,:,1) = R .* uint8(mask);
    subimage(:,:,2) = G .* uint8(mask);
    subimage(:,:,3) = B .* uint8(mask);
end