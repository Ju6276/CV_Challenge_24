function [foreground2DCoordinate, foreground, background] = SegmentImage(n, patchsize, fillorder,picture,location)
   
   
  % Display the image and setup initial settings
    %h = figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    

    %hold(location,"on");
    clear foreground2DCoordinate;
    clear foreground;
    clear background;
    background = picture;
    foreground = cell(1, n);
    foreground2DCoordinate = cell(1, n);

    % Process each foreground object
    for i = 1:n
        ROI{i} = drawpolygon(location,'Color', 'w', 'LineWidth', 1.5); % Draw ROI
        hold(location,"on");

        wait(ROI{i}); % Wait for user to finalize ROI
        X = ROI{i}.Position;
        foreground2DCoordinate{i} = X; % Store coordinates
        foregroundmask = createMask(ROI{i}, picture); % Create mask
        foreground{i} = picture .* uint8(repmat(foregroundmask, [1, 1, 3])); % Extract foreground
    end

    for i = 1:n
        
        background = inpaintExemplar(background, createMask(ROI{i}), 'PatchSize', patchsize, 'FillOrder', fillorder);
    
    end

end


