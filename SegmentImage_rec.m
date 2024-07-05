function [forepoints2D, foreground, background] = SegmentImage(n, patchsize, fillorder,picture,location)
   
   
  % Display the image and setup initial settings
    %h = figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    

    %hold(location,"on");
    clear forepoints2D;
    clear foreground2DCoordinate;
    clear foreground;
    clear background;
    background = picture;
    foreground = cell(1, n);
    foreground2DCoordinate = cell(1, n);

    % Process each foreground object
    for i = 1:n
        ROI{i} = drawrectangle(location,'Color', 'w', 'LineWidth', 1.5); % Draw ROI
        hold(location,"on");
        % Wait for user to finalize ROI
        wait(ROI{i}); 
        % get ROI position and create mask
        X = ROI{i}.Position;
        % Store coordinates
        
        foreground2DCoordinate{i} = X; 
        
        
        % Create mask
        foregroundmask = createMask(ROI{i}, picture); 
        % Extract foreground
        foreground = applyMask(picture, foregroundmask);
         % foreground{i} = picture .* uint8(repmat(foregroundmask, [1, 1, 3])); 
    end
    forepoints2D=[X(1), X(2); 
               X(1) + X(3), X(2);
               X(1) + X(3), X(2) + X(4);
               X(1), X(2) + X(4)];
    % fix the background
    for i = 1:n
        
        background = inpaintExemplar(background, createMask(ROI{i}), 'PatchSize', patchsize, 'FillOrder', fillorder);
    
    end

end
