function subimages = Image_Mask(img, points)
    % This function will create the masks for 5 plane

    % For the leftwall, using vertices P11, P7, P1, P5
    x1 = [points(11,1), points(7,1), points(1,1), points(5,1), points(11,1)];
    y1 = [points(11,2), points(7,2), points(1,2), points(5,2), points(11,2)];
    mask1 = poly2mask(x1, y1, size(img,1), size(img,2));
    subimage1 = applyMask(img, mask1);

    % For the rear wall, using vertices P7, P8, P2, P1
    x2 = [points(7,1), points(8,1), points(2,1), points(1,1), points(7,1)];
    y2 = [points(7,2), points(8,2), points(2,2), points(1,2), points(7,2)];
    mask2 = poly2mask(x2, y2, size(img,1), size(img,2));
    subimage2 = applyMask(img, mask2);

    % For the richtwall, using vertices P8, P12, P6, P2
    x3 = [points(8,1), points(12,1), points(6,1), points(2,1), points(8,1)];
    y3 = [points(8,2), points(12,2), points(6,2), points(2,2), points(8,2)];
    mask3 = poly2mask(x3, y3, size(img,1), size(img,2));
    subimage3 = applyMask(img, mask3);

     % For the ceiling, using vertices P9, P10, P8, P7
    x4 = [points(9,1), points(10,1), points(8,1), points(7,1), points(9,1)];
    y4 = [points(9,2), points(10,2), points(8,2), points(7,2), points(9,2)];
    mask4 = poly2mask(x4, y4, size(img,1), size(img,2));
    subimage4 = applyMask(img, mask4);

    % For the floor, using vertices P1, P2, P4, P3
    x5 = [points(1,1), points(2,1), points(4,1), points(3,1), points(1,1)];
    y5 = [points(1,2), points(2,2), points(4,2), points(3,2), points(1,2)];
    mask5 = poly2mask(x5, y5, size(img,1), size(img,2));
    subimage5 = applyMask(img, mask5);
    
    subimages = {subimage1, subimage2, subimage3, subimage4, subimage5};
   
end

