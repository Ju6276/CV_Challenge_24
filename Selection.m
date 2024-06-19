function [vp,corners,xIntersect, yIntersect,xExtended, yExtended] = Selection(picture)
    
    %h=figure('Name', 'Foreground and Background Separation', 'Position', [100, 100, 700, 400]);
    figure,imshow(picture),hold on;

    % 选择消失点
    disp('点击以选择消失点。');
    vanishingPoint = drawpoint('Color', 'yellow'); 
    wait(vanishingPoint);
    vp = vanishingPoint.Position;

    % 标记消失点0
    text(vp(1), vp(2), '0', 'Color', 'yellow', 'FontSize', 20, 'FontWeight', 'bold');

    % 绘制矩形
    disp('现在绘制矩形。');
    innerRectangle = drawrectangle('Color', 'red', 'LineWidth', 2);
    wait(innerRectangle);
    corners = [innerRectangle.Position(1), innerRectangle.Position(2); 
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2);
               innerRectangle.Position(1), innerRectangle.Position(2) + innerRectangle.Position(4);
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2) + innerRectangle.Position(4)];

    % 标记矩形顶点
    for i = 1:4
        text(corners(i, 1), corners(i, 2), num2str(i), 'Color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');
    end

    % 计算并绘制从消失点到矩形顶点并延伸到图像边界的线
    
    OutterPoints = zeros(4, 2); % 存储与图像边界交点的坐标
    ExtendedPoints = zeros(4, 2); % 存储延伸后的交点坐标
    for i = 1:4
        [xIntersect, yIntersect] = extendLineToBoundary(vp, corners(i, :), size(picture));
        if isempty(xIntersect) || isempty(yIntersect)
            disp('交点在图像边界之外。');
        else
            line([vp(1), xIntersect], [vp(2), yIntersect], 'Color', 'g', 'LineWidth', 2);
            plot(xIntersect, yIntersect, 'ro'); % 标记交点
            text(xIntersect, yIntersect, num2str(i + 4), 'Color', 'magenta', 'FontSize', 20, 'FontWeight', 'bold');
            OutterPoints(i, :) = [xIntersect, yIntersect];
            
            [xExtended, yExtended] = extendLineBeyondBoundary(corners(i, :), [xIntersect, yIntersect], size(picture));
            line([corners(i, 1), xExtended], [corners(i, 2), yExtended], 'Color', 'c', 'LineWidth', 2);
            plot(xExtended, yExtended, 'bo'); % 标记延伸交点
            text(xExtended, yExtended, num2str(i + 8), 'Color', 'cyan', 'FontSize', 20, 'FontWeight', 'bold');
            ExtendedPoints(i, :) = [xExtended, yExtended];
        end
    end
    %close(h);
end



