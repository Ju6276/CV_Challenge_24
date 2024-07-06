function [output_vertices]= Build3DModel_withoutfore(points, img)
% this function transform the 6 plane(rear wall, ceiling, floor, leftwall, 
% rightwall, foreground) into a 3D sapce. 
% At first all 2D pixel coordinates will be transformed to 2D screen coordinate. 
% We constraint the size of the screen coordinate to 2*2.
% The x axis belongs to [-1,1]. The y axis is also from -1 to 1.
% The origin is the point (0,0), at the center point of the image.
% Then tansform them to 3D coordinates.


    %%% Variable declaration
    % Input global variables
    global vanishingpoint_x vanishingpoint_y screen_coordinatesX screen_coordinatesY
    global foreobj_exist image
    

    % Output global variables
    global R output_vertices 
    % global minXScreen maxXScreen minYScreen maxYScreen
    global view_point  
    % global screenWidth screenHeight
    foreobj_exist = 1;

    global plot_check_3D_model
    plot_check_3D_model =1;

    global on_leftwall
    on_leftwall =0;

     global on_rightwall
    on_rightwall =1;

     global on_floor
    on_floor =0;

     global on_ceiling
    on_ceiling =0;

    % Initialize the image size
    size_image = size(img);

    % Assign points to global variables
    vanishingpoint_x = points(13, 1);
    vanishingpoint_y = points(13, 2);
    screen_coordinatesX = points(1:12, 1)';
    screen_coordinatesY = points(1:12, 2)';
    image = img;

    % Get the pixel coordinates
    output_vertices_in_pixel = zeros(2, 13);
    output_vertices_in_pixel(1, 1:13) = [vanishingpoint_x, screen_coordinatesX]; 
    output_vertices_in_pixel(2, 1:13) = [vanishingpoint_y, screen_coordinatesY];

    fore_2D_in_screen = zeros(2, 4);

    


    % Transformation the vertices from pixel coordinates to screen coordinates
    % The origin from top left to the center of the image
    % Flip over the y axis
    output_vertices_in_screen(1, 1:13) = output_vertices_in_pixel(1, 1:13) - (size_image(2) + 1) / 2;
    output_vertices_in_screen(2, 1:13) = -(output_vertices_in_pixel(2, 1:13) - (size_image(1) + 1) / 2);

    % Normalization the size of screen coordinate to 2*2 (x,y [-1, 1])
    output_vertices_in_screen(1, 1:13) = output_vertices_in_screen(1, 1:13) / ((size_image(2) - 1) / 2);
    output_vertices_in_screen(2, 1:13) = output_vertices_in_screen(2, 1:13) / ((size_image(1) - 1) / 2);

   

    % Position of view point in world coordinates
    view_point = [output_vertices_in_screen(1, 1), output_vertices_in_screen(2, 1), 0];
    
    %%% How to determine 3D vanishing point as well as 12 vertices 
    % For the points on "Floor" (1,2,3,4,5,6), let the floor be on y=-1
    for i = 2:7

        % Objects in space appear larger when they are closer and smaller when they are farther away.
        % the weight function can represent the scaling relationship between objcts.
        weight_floor = -(1 + view_point(2)) / (output_vertices_in_screen(2, i) - view_point(2));

        % Compute xyz for points 1 2 3 4 5 6
        output_vertices(1, i) = weight_floor * (output_vertices_in_screen(1, i) - view_point(1)) + view_point(1);
        output_vertices(2, i) = -1;
        output_vertices(3, i) = weight_floor * (-1 - view_point(3)) + view_point(3);
    end

    % Vanishing point depth
    output_vertices(1:2, 1) = output_vertices_in_screen(1:2, 1);
    output_vertices(3, 1) = output_vertices(3, 2);

    % Compute the height of the box. It equal to the y-difference between
    % point 7 and point 1 and the depth.
    height = (output_vertices_in_screen(2, 8) - output_vertices_in_screen(2, 2)) * -output_vertices(3, 1);

    % y axis beginn with -1
    y_ceiling = height - 1;

    % x of leftwall is the same with point 1
    x_left_wall = output_vertices(1, 2);

    % x of rightwall is the same with point 2
    x_right_wall = output_vertices(1, 3);

    % Depth of rearwall is the same with z value of vanishing point
    depth = output_vertices(3, 1);

    % points(1,2,7,8) on rear wall, the position of point 1 & 2 are known
    % for point 7 & 8
    output_vertices(1:3, 8) = [x_left_wall; y_ceiling; depth];
    output_vertices(1:3, 9) = [x_right_wall; y_ceiling; depth];

    % For vertices on ceiling wall
    for i = 10:13
        % weight function for vertices from 1 to 6
        weight_ceiling = (height - 1 - view_point(2)) / (output_vertices_in_screen(2, i) - view_point(2));
        % corresponding 3D coordinates
        output_vertices(1, i) = weight_ceiling * (output_vertices_in_screen(1, i) - view_point(1)) + view_point(1);
        output_vertices(2, i) = y_ceiling;
        output_vertices(3, i) = weight_ceiling * (-1 - view_point(3)) + view_point(3);
    end

    



    %%% Plot fore- and background of the scene in a xyz-axis
    % figure
    % % For inner rectangle
    % plot3([output_vertices(1, 2), output_vertices(1, 3)], [output_vertices(2, 2), output_vertices(2, 3)], [output_vertices(3, 2), output_vertices(3, 3)], 'b')
    % hold on
    % plot3([output_vertices(1, 3), output_vertices(1, 9)], [output_vertices(2, 3), output_vertices(2, 9)], [output_vertices(3, 3), output_vertices(3, 9)], 'b')
    % plot3([output_vertices(1, 9), output_vertices(1, 8)], [output_vertices(2, 9), output_vertices(2, 8)], [output_vertices(3, 9), output_vertices(3, 8)], 'b')
    % plot3([output_vertices(1, 8), output_vertices(1, 2)], [output_vertices(2, 8), output_vertices(2, 2)], [output_vertices(3, 8), output_vertices(3, 2)], 'b')
    % 
    % % For floor
    % plot3([output_vertices(1, 2), output_vertices(1, 4)], [output_vertices(2, 2), output_vertices(2, 4)], [output_vertices(3, 2), output_vertices(3, 4)], 'b')
    % plot3([output_vertices(1, 4), output_vertices(1, 5)], [output_vertices(2, 4), output_vertices(2, 5)], [output_vertices(3, 4), output_vertices(3, 5)], 'b')
    % plot3([output_vertices(1, 5), output_vertices(1, 3)], [output_vertices(2, 5), output_vertices(2, 3)], [output_vertices(3, 5), output_vertices(3, 3)], 'b')
    % 
    % % For left wall
    % plot3([output_vertices(1, 8), output_vertices(1, 12)], [output_vertices(2, 8), output_vertices(2, 12)], [output_vertices(3, 8), output_vertices(3, 12)], 'b')
    % plot3([output_vertices(1, 6), output_vertices(1, 12)], [output_vertices(2, 6), output_vertices(2, 12)], [output_vertices(3, 6), output_vertices(3, 12)], 'b')
    % plot3([output_vertices(1, 6), output_vertices(1, 2)], [output_vertices(2, 6), output_vertices(2, 2)], [output_vertices(3, 6), output_vertices(3, 2)], 'b')
    % 
    % % For right wall
    % plot3([output_vertices(1, 13), output_vertices(1, 9)], [output_vertices(2, 13), output_vertices(2, 9)], [output_vertices(3, 13), output_vertices(3, 9)], 'b')
    % plot3([output_vertices(1, 13), output_vertices(1, 7)], [output_vertices(2, 13), output_vertices(2, 7)], [output_vertices(3, 13), output_vertices(3, 7)], 'b')
    % plot3([output_vertices(1, 7), output_vertices(1, 3)], [output_vertices(2, 7), output_vertices(2, 3)], [output_vertices(3, 7), output_vertices(3, 3)], 'b')
    % 
    % % For ceiling
    % plot3([output_vertices(1, 8), output_vertices(1, 10)], [output_vertices(2, 8), output_vertices(2, 10)], [output_vertices(3, 8), output_vertices(3, 10)], 'b')
    % plot3([output_vertices(1, 10), output_vertices(1, 11)], [output_vertices(2, 10), output_vertices(2, 11)], [output_vertices(3, 10), output_vertices(3, 11)], 'b')
    % plot3([output_vertices(1, 11), output_vertices(1, 9)], [output_vertices(2, 11), output_vertices(2, 9)], [output_vertices(3, 11), output_vertices(3, 9)], 'b')
    % 
    % % For foreground
    % if foreobj_exist==true
    %     plot3([foreobj_3D(1, 4), foreobj_3D(1, 3)], [foreobj_3D(2, 4), foreobj_3D(2, 3)], [foreobj_3D(3, 4), foreobj_3D(3, 3)], 'r');
    %     plot3([foreobj_3D(1, 3), foreobj_3D(1, 2)], [foreobj_3D(2, 3), foreobj_3D(2, 2)], [foreobj_3D(3, 3), foreobj_3D(3, 2)], 'r');
    %     plot3([foreobj_3D(1, 2), foreobj_3D(1, 1)], [foreobj_3D(2, 2), foreobj_3D(2, 1)], [foreobj_3D(3, 2), foreobj_3D(3, 1)], 'r');
    %     plot3([foreobj_3D(1, 1), foreobj_3D(1, 4)], [foreobj_3D(2, 1), foreobj_3D(2, 4)], [foreobj_3D(3, 1), foreobj_3D(3, 4)], 'r');
    % end
    % 
    % scatter3(output_vertices(1, 1:13), output_vertices(2, 1:13), output_vertices(3, 1:13), 'g');
    % 
    % for i = 1:13
    %     num = num2str(i - 1);
    %     text(output_vertices(1, i), output_vertices(2, i), output_vertices(3, i), num, 'color', 'red');
    % end
    % 
    % 
    % %%% zticks(-3.5:0.1:-1)
    % % Drawing lines for foreobject 
    % xlabel('x')
    % ylabel('y')
    % zlabel('z')
    % hold off


   
