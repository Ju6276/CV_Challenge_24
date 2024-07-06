function [transformed_foreground, transformed_subimages]  = apply_perspective_transforms(img, points, foreground, foreground2DCoordinate, foreground_sub)
%%% Implement perspective transformation of the foreground.

    % Determine the size of the foreground output 
    outH_fore = 600* (size(foreground,1)/size(img,1));
    outW_fore = 800* (size(foreground,2)/size(img,2));
 
    % Add the 2D coordinates of foreground vertices to corners_fore
    corners_fore = [foreground2DCoordinate(1,1),foreground2DCoordinate(2,1);
                    foreground2DCoordinate(1,2),foreground2DCoordinate(2,2);
                    foreground2DCoordinate(1,3),foreground2DCoordinate(2,3);
                    foreground2DCoordinate(1,4),foreground2DCoordinate(2,4)];

    % Apply the perspective transformation to the foreground
    transformed_foreground = Perspective_transform(foreground_sub, corners_fore, outH_fore, outW_fore);

    % Get 5 mask of the background
    subimages = image_mask(img, points);  

    % Determine the size of the background output 
    outH = 600;
    outW = 800;

    % Initialize a cell array to store transformed subimages 
    transformed_subimages = cell(1, 5);

    % Define the corner points for each subimage
    corners = {
        [points(11,1), points(11,2); points(7,1), points(7,2); points(1,1), points(1,2); points(5,1), points(5,2)], % leftwall
        [points(7,1), points(7,2); points(8,1), points(8,2); points(2,1), points(2,2); points(1,1), points(1,2)],   % rear wall
        [points(8,1), points(8,2); points(12,1), points(12,2); points(6,1), points(6,2); points(2,1), points(2,2)], % rightwall
        [points(9,1), points(9,2); points(10,1), points(10,2); points(8,1), points(8,2); points(7,1), points(7,2)], % ceiling
        [points(1,1), points(1,2); points(2,1), points(2,2); points(4,1), points(4,2); points(3,1), points(3,2)]    % floor
    };

    % Apply the perspective transformation to every subimage
    % Make sure each subimage and its corresponding corner points 
    % are correctly passed to the Perspective_transform function
    for i = 1:5
       
        transformed_subimages{i} = Perspective_transform(subimages{i}, corners{i}, outH, outW);
    end

    % display the transformed image
    % figure;
    % for i = 1:5
    %     subplot(2, 3, i);
    %     imshow(transformed_subimages{i});
    %     title(sprintf('Transformed Image %d', i));
    % end
end