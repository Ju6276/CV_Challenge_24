function warpImage(img, points)
    % 确保 points 是一个4x3的矩阵，其中列对应X, Y, Z坐标
    if size(points, 1) ~= 4 || size(points, 2) ~= 3
        error('Points matrix must be a 4x3 matrix [x, y, z].');
    end
    
    % 提取每个点的坐标
    x = points(:, 1);
    y = points(:, 2);
    z = points(:, 3);
    
    % 放大 Z 轴值
    z = z * 100;  % 可根据需要调整缩放因子

    % 创建 X, Y, Z 网格
    X = [x(1), x(2); x(4), x(3)];
    Y = [y(1), y(2); y(4), y(3)];
    Z = [z(1), z(2); z(4), z(3)];

    % 映射纹理到网格
    surface = surf(X, Y, Z, 'CData', img, 'FaceColor', 'texturemap', 'EdgeColor', 'none');
    
    % 调整视图以优化显示效果
    view(3);
    axis equal vis3d;
    camlight;
    lighting gouraud;
end
