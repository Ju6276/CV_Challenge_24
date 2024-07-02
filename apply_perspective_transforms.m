function transformed_subimages = apply_perspective_transforms(img, points)
    % 获取五个子图
    subimages = image_mask(img, points);  % 确保这一步正确执行
outH = 600;
outW = 800;
    % 初始化存储变换后子图的 cell 数组
    transformed_subimages = cell(1, 5);

    % 为每个子图定义透视变换的角点，这些角点需要根据具体情况调整
    corners = {
        [points(11,1), points(11,2); points(7,1), points(7,2); points(1,1), points(1,2); points(5,1), points(5,2)], % 左墙
        [points(7,1), points(7,2); points(8,1), points(8,2); points(2,1), points(2,2); points(1,1), points(1,2)],   % 后墙
        [points(8,1), points(8,2); points(12,1), points(12,2); points(6,1), points(6,2); points(2,1), points(2,2)], % 右墙
        [points(9,1), points(9,2); points(10,1), points(10,2); points(8,1), points(8,2); points(7,1), points(7,2)], % 天花板
        [points(1,1), points(1,2); points(2,1), points(2,2); points(4,1), points(4,2); points(3,1), points(3,2)]    % 地板
    };

    % 应用透视变换到每个子图
    for i = 1:5
        % 确保每个子图和对应的角点能正确传递给 Perspective_transform 函数
        transformed_subimages{i} = Perspective_transform(subimages{i}, corners{i}, outH, outW);
    end

    % 显示变换后的图像
    % figure;
    % for i = 1:5
    %     subplot(2, 3, i);
    %     imshow(transformed_subimages{i});
    %     title(sprintf('Transformed Image %d', i));
    % end
end
