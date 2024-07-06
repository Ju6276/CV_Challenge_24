function transformed_subimages = To_Rectangle_Usage(img, points)
    %%% Implement perspective transformation of the background. 

% Get 5 mask of the background
    subimages = Image_Mask(img, points);  
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
        
        transformed_subimages{i} = To_Rectangle(subimages{i}, corners{i}, outH, outW);
    end

   
end
