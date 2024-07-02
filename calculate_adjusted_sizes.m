function adjustedSizes = calculate_adjusted_sizes(points, vp)
    % 定义墙面角点数组
    wall_corners = {
        [points(11,:); points(7,:); points(1,:); points(5,:)], % 左墙
        [points(7,:); points(8,:); points(2,:); points(1,:)], % 后墙
        [points(8,:); points(12,:); points(6,:); points(2,:)], % 右墙
        [points(9,:); points(10,:); points(8,:); points(7,:)], % 天花板
        [points(1,:); points(2,:); points(4,:); points(3,:)] % 地板
    };

    % 初始化输出矩阵和基本尺寸
    outH = 600;
    outW = 800;
    distances = zeros(size(wall_corners));

    % 计算每面墙到消失点的平均距离
    for i = 1:length(wall_corners)
        corners = wall_corners{i};
        distances(i) = mean(calc_distance(vp, corners));
    end

    % 后墙距离作为基准
    baseDist = distances(2);
    adjustedSizes = zeros(length(wall_corners), 2);

    % 调整每个墙面的尺寸
    for i = 1:length(wall_corners)
        [newH, newW] = adjust_size(outH, outW, baseDist, distances(i));
        adjustedSizes(i, :) = [newH, newW];
    end

    % 内部函数：计算距离
    function dist = calc_distance(vp, corners)
        dist = sqrt((vp(1) - corners(:,1)).^2 + (vp(2) - corners(:,2)).^2);
    end

    % 内部函数：调整尺寸
    function [newH, newW] = adjust_size(outH, outW, baseDist, currentDist)
        factor = baseDist / currentDist;  % 距离和尺寸成反比
        newH = round(outH * factor);
        newW = round(outW * factor);
    end
end
