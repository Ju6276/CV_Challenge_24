function [img, points2D] = adjustForNegativeCoordinates(img, points2D)
    minX = min(points2D(:, 1));
    minY = min(points2D(:, 2));
    padX = 0;
    padY = 0;
    
    if minX < 0
        padX = ceil(abs(minX)) + 1;
    end
    if minY < 0
        padY = ceil(abs(minY)) + 1;
    end
    
    img = padarray(img, [padY, padX], 0, 'pre');
    points2D(:, 1) = points2D(:, 1) + padX;
    points2D(:, 2) = points2D(:, 2) + padY;
    
    figure;
    imshow(img);
    hold on;
    plot(points2D(:, 1), points2D(:, 2), 'ro');
    title('Padded Image with Adjusted Coordinates');
end
