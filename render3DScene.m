function render3DScene(transformed_subimages, estimatedVertex,location)
     % figure;
     % hold on;
    estimatedVertex(:,1) = [];  % 删除第一列
    

    % 映射子图像到对应的三维坐标
    %LEFT P11, P7, P1, P5
    warpImage(transformed_subimages{1}, estimatedVertex(1:3, [11, 7, 1, 5])',location);
    %Back P7, P8, P2, P1
    warpImage(transformed_subimages{2}, estimatedVertex(1:3, [7, 8, 2, 1])',location);
    %RIGHT P8, P12, P6, P2
    warpImage(transformed_subimages{3}, estimatedVertex(1:3, [ 8,12,6,2])',location);
    %warpImage(subimages{3}, estimatedVertex(1:3, [ 12,6,2,8])');
    %warpImage(subimages{3}, estimatedVertex(1:3, [ 6,2,8,12])');
    %warpImage(subimages{3}, estimatedVertex(1:3, [ 12,6,2,8])');
    %warpImage(subimages{3}, estimatedVertex(1:3, [ 2,6,12,8])');

    %warpImage(subimages{3}, estimatedVertex(1:3, [ 6,12,8,2])');
  

    %Ceiling P9, P10, P8, P7
    warpImage(transformed_subimages{4}, estimatedVertex(1:3, [9, 10, 8, 7])',location);
    %Floor P1, P2, P4, P3
    %warpImage(subimages{5}, estimatedVertex(1:3, [1,2,4,3])');
    warpImage(transformed_subimages{5}, estimatedVertex(1:3, [1,2,4,3])',location);
    
    
    
    
    % warpImage(transformed_subimages{1}, estimatedVertex(1:3, [11, 7, 1, 5])');
    % %Back P7, P8, P2, P1
    % warpImage(transformed_subimages{2}, estimatedVertex(1:3, [7, 8, 2, 1])');
    % %RIGHT P8, P12, P6, P2
    % warpImage(transformed_subimages{3}, estimatedVertex(1:3, [ 8,12,6,2])');
    %  %Ceiling P9, P10, P8, P7
    % warpImage(transformed_subimages{4}, estimatedVertex(1:3, [9, 10, 8, 7])');
    % %Floor P1, P2, P4, P3
    % %warpImage(subimages{5}, estimatedVertex(1:3, [1,2,4,3])');
    % warpImage(transformed_subimages{5}, estimatedVertex(1:3, [1,2,4,3])');
    
    % 设置视图和轴属性
    % axis vis3d;
     % view(3);
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
     % camlight;
     % lighting gouraud;  % 设置渲染模式为Gouraud，以平滑地插值颜色
    % 
    % hold off;
end
