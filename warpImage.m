function warpImage(img, points)

    % Extract the coordinate of vertices
    x = points(:, 1);
    y = points(:, 2);
    z = points(:, 3);

    % Create X, Y, Z grid
    X = [x(1), x(2); x(4), x(3)];
    Y = [y(1), y(2); y(4), y(3)];
    Z = [z(1), z(2); z(4), z(3)];
    
    % Map texture to the grid
    surf(X, Y, Z, 'CData', img, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    

end
