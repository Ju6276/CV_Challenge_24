function spidery_mesh()
    % Let the user select an image file
    [fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
    if isequal(fileName, 0)
        disp('User selected Cancel');
        return;
    else
        imagePath = fullfile(pathName, fileName);
        img = imread(imagePath);
    end

    % Display the image
    figure, imshow(img), hold on;
    
    % Let the user select the vanishing point
    disp('Click to select the vanishing point.');
    vanishingPoint = drawpoint('Color', 'yellow'); 
    wait(vanishingPoint);
    text(vanishingPoint.Position(1), vanishingPoint.Position(2), '0', 'Color', 'yellow', 'FontSize', 20, 'FontWeight', 'bold');
    
    % Let the user draw the rectangle
    disp('Now draw the rectangle.');
    innerRectangle = drawrectangle('Color', 'red', 'LineWidth', 2);
    wait(innerRectangle);

    % Calculate and draw lines from vanishing point to rectangle corners
    corners = [innerRectangle.Position(1), innerRectangle.Position(2); 
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2);
               innerRectangle.Position(1), innerRectangle.Position(2) + innerRectangle.Position(4);
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2) + innerRectangle.Position(4)];

    % Mark rectangle corners
    for i = 1:4
        text(corners(i, 1), corners(i, 2), num2str(i), 'Color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');
    end

    % Calculate intersections and draw lines
    intersectionCount = 1;
    for i = 1:4
        [xIntersect, yIntersect] = extendLineToBoundary(vanishingPoint.Position, corners(i, :), size(img));
        if isempty(xIntersect) || isempty(yIntersect)
            disp('Intersection point is outside of image boundaries.');
        else
            line([vanishingPoint.Position(1), xIntersect], [vanishingPoint.Position(2), yIntersect], 'Color', 'g', 'LineWidth', 2);
            plot(xIntersect, yIntersect, 'ro'); % Mark the intersection points
            text(xIntersect, yIntersect, ['(', num2str(intersectionCount), ') ', '(', num2str(xIntersect, '%.2f'), ', ', num2str(yIntersect, '%.2f'), ')'], 'Color', 'magenta', 'FontSize',20, 'FontWeight', 'bold');
            intersectionCount = intersectionCount + 1;
        end
    end
end

function [xIntersect, yIntersect] = extendLineToBoundary(vp, corner, imgSize)
    % Calculate intersection using parametric line equations
    dx = corner(1) - vp(1);
    dy = corner(2) - vp(2);
    t = linspace(0, max(imgSize), 10000);  % Generate points along the line

    % Calculate points along the line
    xPoints = vp(1) + t * dx;
    yPoints = vp(2) + t * dy;

    % Find the first point that is outside the image boundaries
    validIndices = xPoints >= 1 & xPoints <= imgSize(2) & yPoints >= 1 & yPoints <= imgSize(1);
    if any(~validIndices)
        firstInvalidIdx = find(~validIndices, 1, 'first') - 1;
        xIntersect = xPoints(firstInvalidIdx);
        yIntersect = yPoints(firstInvalidIdx);
    else
        xIntersect = [];
        yIntersect = [];
    end
end
