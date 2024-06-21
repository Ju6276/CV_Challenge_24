function ImageProcessing()
    [fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
    if isequal(fileName, 0)
        disp('User selected Cancel');
        return;
    else
        imagePath = fullfile(pathName, fileName);
        im1 = imread(imagePath);
    end

    % Rotate the image
    im1 = rotateImage(im1);

    % Ask the user to specify the number of foreground objects
    answer = inputdlg('Enter the number of foreground objects:', 'Number of Foregrounds', [1 50]);
    if isempty(answer)
        disp('No number provided, defaulting to 1');
        n = 1;
    else
        n = str2double(answer{1});
        if isnan(n) || n < 1
            disp('Invalid input, defaulting to 1');
            n = 1;
        end
    end

    % Now proceed with the image segmentation
    [foreground2DCoordinate, foreground, background] = segmentImage(im1, n);
end
