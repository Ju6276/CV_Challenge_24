function [xExtended, yExtended] = extendLineBeyondBoundary(corner, boundaryPoint, imgSize)
    % 计算与图像边界延长线的交点
    dx = boundaryPoint(1) - corner(1);
    dy = boundaryPoint(2) - corner(2);
    imgWidth = imgSize(2);
    imgHeight = imgSize(1);
    
    if boundaryPoint(1) == 1 || boundaryPoint(1) == imgWidth
        % 垂直边界线的延长
        if dy ~= 0
            if boundaryPoint(2) < corner(2)
                yExtended = 0;
            else
                yExtended = imgHeight + 1;
            end
            t = (yExtended - boundaryPoint(2)) / dy;
            xExtended = boundaryPoint(1) + t * dx;
        else
            xExtended = boundaryPoint(1);
            yExtended = boundaryPoint(2);
        end
    else
        % 水平边界线的延长
        if dx ~= 0
            if boundaryPoint(1) < corner(1)
                xExtended = 0;
            else
                xExtended = imgWidth + 1;
            end
            t = (xExtended - boundaryPoint(1)) / dx;
            yExtended = boundaryPoint(2) + t * dy;
        else
            xExtended = boundaryPoint(1);
            yExtended = boundaryPoint(2);
        end
    end
end
