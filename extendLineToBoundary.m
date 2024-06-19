function [xIntersect, yIntersect] = extendLineToBoundary(vp, corner, imgSize)
    % 计算使用参数化直线方程的交点
    dx = corner(1) - vp(1);
    dy = corner(2) - vp(2);
    t = linspace(0, 10, 1000);  % 沿直线生成点

    % 计算沿直线的点
    xPoints = vp(1) + t * dx;
    yPoints = vp(2) + t * dy;

    % 找到第一个在图像边界之外的点
    validIndices = xPoints >= 1 & xPoints <= imgSize(2) & yPoints >= 1 & yPoints <= imgSize(1);
    if any(~validIndices)
        firstInvalidIdx = find(~validIndices, 1, 'first') - 1;
        xIntersect = xPoints(firstInvalidIdx);
        yIntersect = yPoints(firstInvalidIdx);
    else
        xIntersect = [];
        yIntersect = [];
    end
end