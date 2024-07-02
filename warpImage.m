function warpImage(img, points,location)

    % 提取每个点的坐标
    x = points(:, 1);
    y = points(:, 2);
    z = points(:, 3);

    % 创建 X, Y, Z 网格
    X = [x(1), x(2); x(4), x(3)];
    Y = [y(1), y(2); y(4), y(3)];
    Z = [z(1), z(2); z(4), z(3)];
    
    % 映射纹理到网格
    surf(location,X, Y, Z, 'CData', img, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    

end
