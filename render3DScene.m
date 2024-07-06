function render3DScene(transformed_subimages, output_vertices,transformed_foreground,fore_output_vertices)
    figure;
    hold on
    % Delete the vanishing point position (first column of output_vertices)
    output_vertices(:,1) = [];  
    

    % Map the subimage to the corresponding 3D coordinates.
    % For leftwall with P11, P7, P1, P5
    warpImage(transformed_subimages{1}, output_vertices(1:3, [11, 7, 1, 5])');
    % For rear wall with P7, P8, P2, P1
    warpImage(transformed_subimages{2}, output_vertices(1:3, [7, 8, 2, 1])');
    % For rightwall with P8, P12, P6, P2
    warpImage(transformed_subimages{3}, output_vertices(1:3, [ 8,12,6,2])');
    % For ceiling wtih P9, P10, P8, P7
    warpImage(transformed_subimages{4}, output_vertices(1:3, [9, 10, 8, 7])');
    % For floor with P1, P2, P4, P3
    warpImage(transformed_subimages{5}, output_vertices(1:3, [1,2,4,3])');
    % For foreground
    warpImage(transformed_foreground, fore_output_vertices(1:3, [1,2,3,4])');
   
    
    % Set view and axis properties 
    axis vis3d;
    view(3);
    %hold on
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    camlight;
    % Set the rendering mode as 'Gouraud' for smooth color interpolation.
    lighting gouraud;  
    hold off;
end