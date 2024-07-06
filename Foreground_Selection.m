function [foreground2DCoordinate, foreground, background] = Foreground_Selection(patchsize, fillorder,picture,location)
% Choose the foreground from the picture
% Get the vertices coordinates and the image of the foreground
   
    % Display the image and setup initial settings
    %h = figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    

    %hold(location,"on");
    clear foreground2DCoordinate;
    clear foreground;
    clear background;
    background = picture;
    foreground = zeros(1, 1);
    foreground2DCoordinate = zeros(1, 1);

    % Process for foreground object
    % Draw ROI
 
    ROI = drawrectangle(location,'Color', 'w', 'LineWidth', 1.5); 
    hold(location,"on")
    % Wait for user to finalize ROI
    wait(ROI); 
    disp(ROI);
        
    X= [ROI.Position(1),ROI.Position(1) + ROI.Position(3),ROI.Position(1) + ROI.Position(3),ROI.Position(1);
        ROI.Position(2),ROI.Position(2), ROI.Position(2) + ROI.Position(4), ROI.Position(2) + ROI.Position(4)];
        
    % Store 2D pixel coordinates of foreground
    foreground2DCoordinate = X;
        
    % Create mask for foreground
    foregroundmask = createMask(ROI, picture); 
        
    % Extract foreground image
     foreground = picture .* uint8(repmat(foregroundmask, [1, 1, 3]));
     % foreground = applyMask(picture, foregroundmask);

    % Fix the background 
    
     background = inpaintExemplar(background, createMask(ROI), 'PatchSize', patchsize, 'FillOrder', fillorder);
    
end
