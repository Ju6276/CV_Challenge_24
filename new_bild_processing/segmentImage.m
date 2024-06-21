function [foreground2DCoordinate, foreground, background] = segmentImage(im1, n, patchsize, fillorder)
    % Set default values if not provided
    if nargin < 3 || isempty(patchsize)
        patchsize = 9; % defalut
    end
    if nargin < 4 || isempty(fillorder)
        fillorder = 'gradient'; % defalut
    end

    % Display the image and setup initial settings
    h = figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    imshow(im1);
    background = im1;
    foreground = cell(1, n);
    foreground2DCoordinate = cell(1, n);

    % Process each foreground object
    for i = 1:n
        ROI{i} = drawpolygon('Color', 'w', 'LineWidth', 1.5); % Draw ROI
        wait(ROI{i}); % Wait for user to finalize ROI
        X = ROI{i}.Position;
        foreground2DCoordinate{i} = X; % Store coordinates
        foregroundmask = createMask(ROI{i}, im1); % Create mask
        foreground{i} = im1 .* uint8(repmat(foregroundmask, [1, 1, 3])); % Extract foreground
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

    % Display the final inpainted background image
    figure('Name', 'Inpainted Background Image', 'Position', [100, 100, 700, 400]);
    imshow(background);
    title('Background After Removing Foreground');
end
