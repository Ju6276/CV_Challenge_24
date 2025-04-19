function render3DScene(subimages, points3D)
    figure;
    hold on;

    % 映射子图像到对应的三维坐标
    warpImage(subimages{1}, points3D([11, 7, 1, 5], :));
    warpImage(subimages{2}, points3D([7, 8, 2, 1], :));
    warpImage(subimages{3}, points3D([8, 12, 6, 2], :));
    warpImage(subimages{4}, points3D([9, 10, 8, 7], :));
    warpImage(subimages{5}, points3D([1, 2, 4, 3], :));

    % 设置视图和轴属性
    axis vis3d;
    view(3);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');

    % 添加光照
    camlight;  % 添加相机位置的光源
    lighting gouraud;  % 设置渲染模式为Gouraud，以平滑地插值颜色

    hold off;
end
