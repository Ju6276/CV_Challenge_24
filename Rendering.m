function Rendering(transformed_subimages, estimatedVertex,location)
    
% Delete the vanishing point position (first column of output_vertices)
    estimatedVertex(:,1) = [];  
    
% Map the subimage to the corresponding 3D coordinates.
    %LEFT P11, P7, P1, P5
    SurfImage(transformed_subimages{1}, estimatedVertex(1:3, [11, 7, 1, 5])',location);
    %Back P7, P8, P2, P1
    SurfImage(transformed_subimages{2}, estimatedVertex(1:3, [7, 8, 2, 1])',location);
    %RIGHT P8, P12, P6, P2
    SurfImage(transformed_subimages{3}, estimatedVertex(1:3, [ 8,12,6,2])',location);
    
  

    %Ceiling P9, P10, P8, P7
    SurfImage(transformed_subimages{4}, estimatedVertex(1:3, [9, 10, 8, 7])',location);
    %Floor P1, P2, P4, P3
    %warpImage(subimages{5}, estimatedVertex(1:3, [1,2,4,3])');
    SurfImage(transformed_subimages{5}, estimatedVertex(1:3, [1,2,4,3])',location);
    
    % % Set view and axis properties 
    % axis vis3d;
    % view(3);
    % %hold on
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % camlight;
    % % Set the rendering mode as 'Gouraud' for smooth color interpolation.
    % lighting gouraud;  
    % hold off;
    % 
    % 
  
    
   
end
