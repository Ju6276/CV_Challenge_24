function points3D = convertPointsTo3D(points)

    vanishingPoint = points(13, :);
    

    otherPoints = points(1:12, :);
    

    points3D = zeros(size(otherPoints, 1), 3);
    

    for i = 1:size(otherPoints, 1)

        points3D(i, :) = twodim_threedim(vanishingPoint(1), vanishingPoint(2), otherPoints(i, 1), otherPoints(i, 2));
    end
end
