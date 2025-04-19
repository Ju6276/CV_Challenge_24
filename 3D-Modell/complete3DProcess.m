function complete3DProcess()

    [points, img] = Selection();
    
    if isempty(points)
        disp('No points were selected or the process was cancelled.');
        return;
    end
    

    [~, points] = adjustForNegativeCoordinates(img, points);
    
    points3D = convertPointsTo3D(points);


    disp(points3D);
subimages = image_mask(img, points);

    disp(size(subimages));  
    render3DScene(subimages, points3D);
end
