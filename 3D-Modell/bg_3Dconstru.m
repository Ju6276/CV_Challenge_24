function [points3D, Vanishing_point_3D] = bg_3Dconstru(points, k)
    % 假设消失点用来计算所有点的深度
    Vanishing_point_3D = twodim_threedim(points(13, 1), points(13, 2), points(13, 1), points(13, 2));
    
    % 初始化3D点数组
    points3D = zeros(12, 3);
    for i = 1:12
        % 使用修改后的twodim_threedim函数计算3D坐标
        points3D(i, :) = twodim_threedim(points(13, 1), points(13, 2), points(i, 1), points(i, 2));
    end

    % 地板点设置y=0
    points3D([1, 2, 3, 4,5,6], 2) = 0;  % P1, P2, P3, P4 是地板，设置为y=0

    % 后墙上边界点的y值计算 
    H = mean(points3D([7, 8], 2));  % P7, P8 是后墙上边界，计算其平均高度

    % 设置后墙和天花板的y值
    points3D([9, 10, 11, 12], 2) = H;  % P7, P8, P9, P10 的y设置为H

    % 设置墙面的垂直约束
    % 这里可以进一步通过角度或者其他方法来校正墙面的垂直关系

    % 调整深度缩放
    points3D(:, 3) = points3D(:, 3) * k;

end