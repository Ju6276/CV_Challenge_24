function [foreground2DCoordinate, foreground, background] = SegmentImage(n, patchsize, fillorder,picture)
   
   
  % Display the image and setup initial settings
    h = figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    imshow(picture);
    background = picture;
    foreground = cell(1, n);
    foreground2DCoordinate = cell(1, n);

    % Process each foreground object
    for i = 1:n
        ROI{i} = drawpolygon('Color', 'w', 'LineWidth', 1.5); % Draw ROI
        wait(ROI{i}); % Wait for user to finalize ROI
        X = ROI{i}.Position;
        foreground2DCoordinate{i} = X; % Store coordinates
        foregroundmask = createMask(ROI{i}, picture); % Create mask
        foreground{i} = picture .* uint8(repmat(foregroundmask, [1, 1, 3])); % Extract foreground
    end

    % Inpaint background
    d = waitbar(0, 'Image rendering', 'Name', 'Processing Image', 'CreateCancelBtn', 'setappdata(gcbf, ''canceling'', 1)');
    setappdata(d, 'canceling', 0);
    for i = 1:n
        if getappdata(d, 'canceling')
            break;
        end
        background = inpaintExemplar(background, createMask(ROI{i}), 'PatchSize', patchsize, 'FillOrder', fillorder);
        waitbar(i/n, d);
    end
    delete(d); % Clean up
    close(h);

       

end


