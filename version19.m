function points = spidery_mesh()
    % 让用户选择图像文件
    [fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
    if isequal(fileName, 0)
        disp('User selected Cancel');
        points = []; % Return an empty array if user cancels
        return;
    else
        imagePath = fullfile(pathName, fileName);
        img = imread(imagePath);
    end

    % 显示图像
    figure, imshow(img), hold on;
    
    % 让用户选择消失点
    disp('Click to select the vanishing point.');
    vanishingPoint = drawpoint('Color', 'yellow'); 
    wait(vanishingPoint);
    text(vanishingPoint.Position(1), vanishingPoint.Position(2), '0', 'Color', 'yellow', 'FontSize', 20, 'FontWeight', 'bold');
    
    % 存储消失点
    points = zeros(13, 2);
    points(1, :) = vanishingPoint.Position;

    % 让用户绘制矩形
    disp('Now draw the rectangle.');
    innerRectangle = drawrectangle('Color', 'red', 'LineWidth', 2);
    wait(innerRectangle);

    % 计算并存储矩形的四个角点（左下角逆时针顺序）
    corners = [innerRectangle.Position(1), innerRectangle.Position(2); 
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2);
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2) + innerRectangle.Position(4);
               innerRectangle.Position(1), innerRectangle.Position(2) + innerRectangle.Position(4)];
    
    % 标记内部矩形的四个点
    labels = [1, 2, 7, 8];
    for i = 1:4
        points(labels(i), :) = corners(i, :);
        text(corners(i, 1), corners(i, 2), num2str(labels(i)), 'Color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');
    end

    % 计算并绘制从消失点到图像边界的线段，并存储交点
    labels = [3, 4, 10, 9];
    for i = 1:4
        [xIntersect, yIntersect] = extendLineToBoundary(vanishingPoint.Position, corners(i, :), size(img));
        if ~isempty(xIntersect) && ~isempty(yIntersect)
            % 存储与图像边界的交点
            points(labels(i), :) = [xIntersect, yIntersect];
            
            % 绘制从消失点到图像边界的线段
            line([vanishingPoint.Position(1), xIntersect], [vanishingPoint.Position(2), yIntersect], 'Color', 'g', 'LineWidth', 2);
            plot(xIntersect, yIntersect, 'ro'); % 标记交点
            text(xIntersect, yIntersect, num2str(labels(i)), 'Color', 'magenta', 'FontSize', 20, 'FontWeight', 'bold');
            
            % 计算并绘制从交点到图像延长边界的线段，并存储延长线交点
            [xBeyond, yBeyond] = extendLineBeyondBoundary([xIntersect, yIntersect], vanishingPoint.Position, size(img));
            if ~isempty(xBeyond) && ~isempty(yBeyond)
                % 存储延长线交点
                points(labels(i)+2, :) = [xBeyond, yBeyond];
                
                line([xIntersect, xBeyond], [yIntersect, yBeyond], 'Color', 'c', 'LineWidth', 2, 'LineStyle', '--');
                plot(xBeyond, yBeyond, 'bs'); % 标记延长线交点
                text(xBeyond, yBeyond, num2str(labels(i)+2), 'Color', 'cyan', 'FontSize', 20, 'FontWeight', 'bold');
            end
        end
    end

    % 打印存储的点坐标
    disp('Stored Points:');
    disp(points);
end

function [xIntersect, yIntersect] = extendLineToBoundary(vp, corner, imgSize)
    % 计算使用参数化直线方程的交点
    dx = corner(1) - vp(1);
    dy = corner(2) - vp(2);
    
    % 初始化交点为空
    xIntersect = [];
    yIntersect = [];
    
    % 计算与左边界 (x = 0) 的交点
    if dx ~= 0
        tLeft = (1 - vp(1)) / dx;
        yLeft = vp(2) + tLeft * dy;
        if tLeft > 0 && yLeft >= 1 && yLeft <= imgSize(1)
            xIntersect = 1;
            yIntersect = yLeft;
            return;
        end
    end

    % 计算与右边界 (x = imgSize(2)) 的交点
    if dx ~= 0
        tRight = (imgSize(2) - vp(1)) / dx;
        yRight = vp(2) + tRight * dy;
        if tRight > 0 && yRight >= 1 && yRight <= imgSize(1)
            xIntersect = imgSize(2);
            yIntersect = yRight;
            return;
        end
    end

    % 计算与上边界 (y = 0) 的交点
    if dy ~= 0
        tTop = (1 - vp(2)) / dy;
        xTop = vp(1) + tTop * dx;
        if tTop > 0 && xTop >= 1 && xTop <= imgSize(2)
            xIntersect = xTop;
            yIntersect = 1;
            return;
        end
    end

    % 计算与下边界 (y = imgSize(1)) 的交点
    if dy ~= 0
        tBottom = (imgSize(1) - vp(2)) / dy;
        xBottom = vp(1) + tBottom * dx;
        if tBottom > 0 && xBottom >= 1 && xBottom <= imgSize(2)
            xIntersect = xBottom;
            yIntersect = imgSize(1);
            return;
        end
    end
end

function [xBeyond, yBeyond] = extendLineBeyondBoundary(intersectPoint, vp, imgSize)
    % 计算方向向量
    dx = intersectPoint(1) - vp(1);
    dy = intersectPoint(2) - vp(2);

    % 初始化交点为空
    xBeyond = [];
    yBeyond = [];

    % 计算与延长边界的交点
    % 左边界延长线 (x = 0)
    if dx ~= 0
        tLeft = (0 - intersectPoint(1)) / dx;
        yLeft = intersectPoint(2) + tLeft * dy;
        if tLeft > 0
            xBeyond = 0;
            yBeyond = yLeft;
        end
    end

    % 右边界延长线 (x = imgSize(2))
    if dx ~= 0
        tRight = (imgSize(2) - intersectPoint(1)) / dx;
        yRight = intersectPoint(2) + tRight * dy;
        if tRight > 0
            xBeyond = imgSize(2);
            yBeyond = yRight;
        end
    end

    % 上边界延长线 (y = 0)
    if dy ~= 0
        tTop = (0 - intersectPoint(2)) / dy;
        xTop = intersectPoint(1) + tTop * dx;
        if tTop > 0
            xBeyond = xTop;
            yBeyond = 0;
        end
    end

    % 下边界延长线 (y = imgSize(1))
    if dy ~= 0
        tBottom = (imgSize(1) - intersectPoint(2)) / dy;
        xBottom = intersectPoint(1) + tBottom * dx;
        if tBottom > 0
            xBeyond = xBottom;
            yBeyond = imgSize(1);
        end
    end
end
