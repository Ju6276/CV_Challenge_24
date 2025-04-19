function rotatedImage = rotateImage(image)
    answer = inputdlg('Enter the rotation angle (in degrees):', 'Rotate Image', [1 50]);
    if isempty(answer)
        disp('No rotation applied.');
        rotatedImage = image;
    else
        angle = str2double(answer{1});
        rotatedImage = imrotate(image, angle, 'bilinear', 'crop');
    end
end
