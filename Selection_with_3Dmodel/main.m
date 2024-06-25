% Main script
[points, pathName, fileName] = Selection();
if ~isempty(points)
    img = imread(fullfile(pathName, fileName)); % 确保有path和file
    Build3DModel_new(points, img);
end