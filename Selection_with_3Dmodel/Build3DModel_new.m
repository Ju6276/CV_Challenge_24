function virtual_output = Build3DModel_new(points, img)
    virtual_output = 0;

    %% 1. General Settings for tester
    % If you want to test this function without main function, set this to true
    test_this_function = false;

    % If you want to check the 3D model of the scene, set this to true
    plot_check_3D_Model = true;

    % For more details about this function, read "ReadMe_Build3DModel.txt".

    %% 2. Clarify the Variables & General Variables
    % for the inputs
    global X_VP %#ok<*GVMIS> 
    global Y_VP
    global X_coordinate_matrix
    global Y_coordinate_matrix
    global foreobj_2D   % pixel coordinates
    global given_foreobj
    global image
    if given_foreobj==true
        global on_floor %#ok<*TLEV> 
        global on_ceiling
        global on_leftwall
        global on_rightwall
    end

    % for the outputs
    global estimatedVertex
    global oevminx
    global oevmaxx
    global oevminy
    global oevmaxy
    global oevdiffx
    global oevdiffy
    global View_Point
    global R
    if given_foreobj==true
        global foreObj
    end

    % Initialize some variables
    size_image = size(img);

    % Assign points to global variables
    X_VP = points(13, 1);
    Y_VP = points(13, 2);
    X_coordinate_matrix = points(1:12, 1)';
    Y_coordinate_matrix = points(1:12, 2)';
    image = img;

    estimatedVertex_pixel_coor = zeros(2, 13);
    estimatedVertex_pixel_coor(1, 1:13) = [X_VP, X_coordinate_matrix]; 
    estimatedVertex_pixel_coor(2, 1:13) = [Y_VP, Y_coordinate_matrix];

    foreobj_2D_screen_coor = zeros(2, 4);

    min_x_oev = 0;
    max_x_oev = 0;
    min_y_oev = 0;
    max_y_oev = 0;

    %% 3. Change the Inputs into screen Coordinate System
    % Normalize the coordinates for world coordinate system so that the center
    % of x-y plane is on the center of the image and the size of the image is 
    % 2x2, which means the left and right borders are on x=-1 and 1, so as the 
    % up and down borders are on y=1 and -1

    % translate x- & y-axis, flip y-axis over
    estimatedVertex_screen_coor(1, 1:13) = estimatedVertex_pixel_coor(1, 1:13) - (size_image(2) + 1) / 2;
    estimatedVertex_screen_coor(2, 1:13) = -(estimatedVertex_pixel_coor(2, 1:13) - (size_image(1) + 1) / 2);
    % normalization
    estimatedVertex_screen_coor(1, 1:13) = estimatedVertex_screen_coor(1, 1:13) / ((size_image(2) - 1) / 2);
    estimatedVertex_screen_coor(2, 1:13) = estimatedVertex_screen_coor(2, 1:13) / ((size_image(1) - 1) / 2);

    % we do the same to foreobject
    if given_foreobj==true
        foreobj_2D_screen_coor(1, 1:4) = foreobj_2D(1, 1:4) - (size_image(2) + 1) / 2;
        foreobj_2D_screen_coor(2, 1:4) = -(foreobj_2D(2, 1:4) - (size_image(1) + 1) / 2);
        foreobj_2D_screen_coor(1, 1:4) = foreobj_2D_screen_coor(1, 1:4) / ((size_image(2) - 1) / 2);
        foreobj_2D_screen_coor(2, 1:4) = foreobj_2D_screen_coor(2, 1:4) / ((size_image(1) - 1) / 2);
    end

    %% 4. Derive the View Point in World Coordinate System
    % see lines: 69-72
    View_Point = [estimatedVertex_screen_coor(1, 1), estimatedVertex_screen_coor(2, 1), 0];

    %% 5. Determination of the World Coordinate of Vertices and Vanishing Point
    % In previous implementation we've set the unit length for world coordinate
    % system using the borders of image. Now we consider the situation in 3D
    % view, in this case the 4 borders are definitely not all on the "1", the
    % coordinate should be recalculated.

    % For the points on "Floor" (1,2,3,4,5,6), let the floor be on y=-1
    for i = 2:7
        % The objects near the viewer will be visually larger, we should keep 
        % this in mind. For that we define a proper "weight function".
        weight_fun_floor = -(1 + View_Point(2)) / (estimatedVertex_screen_coor(2, i) - View_Point(2));
        % compute xyz for 1 2 3 4 5 6
        estimatedVertex(1, i) = weight_fun_floor * (estimatedVertex_screen_coor(1, i) - View_Point(1)) + View_Point(1);
        estimatedVertex(2, i) = -1;
        estimatedVertex(3, i) = weight_fun_floor * (-1 - View_Point(3)) + View_Point(3);
    end

    % Relocate the vanishing point, z should be the same with point one
    estimatedVertex(1:2, 1) = estimatedVertex_screen_coor(1:2, 1);
    estimatedVertex(3, 1) = estimatedVertex(3, 2);

    % Calculate the height of the box
    height = (estimatedVertex_screen_coor(2, 8) - estimatedVertex_screen_coor(2, 2)) * -estimatedVertex(3, 1);

    % Some known parameters for now:
    y_ceiling = height - 1;
    x_left_wall = estimatedVertex(1, 2);
    x_right_wall = estimatedVertex(1, 3);
    depth = estimatedVertex(3, 1);

    % For the points on "rear wall" (7, 8)
    estimatedVertex(1:3, 8) = [x_left_wall; y_ceiling; depth];
    estimatedVertex(1:3, 9) = [x_right_wall; y_ceiling; depth];

    % For the points on "ceiling" (9, 10, 11, 12)
    for i = 10:13
        % like points 1-6, we should define a weight function, but a little bit
        % different
        weight_fun_ceiling = (height - 1 - View_Point(2)) / (estimatedVertex_screen_coor(2, i) - View_Point(2));
        % compute xyz for 9 10 11 12
        estimatedVertex(1, i) = weight_fun_ceiling * (estimatedVertex_screen_coor(1, i) - View_Point(1)) + View_Point(1);
        estimatedVertex(2, i) = y_ceiling;
        estimatedVertex(3, i) = weight_fun_ceiling * (-1 - View_Point(3)) + View_Point(3);
    end

    %% 6. Modelling the Fore-Object
    if given_foreobj==true
        if on_floor == true
            % The fore object is standing on the floor
            foreobj_3D = Foreobj3DBuild_Floor(foreobj_2D_screen_coor);
        elseif on_ceiling == true
            % The fore object is hanging to the ceiling
            foreobj_3D = Foreobj3DBuild_Ceiliing(foreobj_2D_screen_coor, y_ceiling);
        elseif on_leftwall == true
            % The fore object is connecting to the left wall
        elseif on_rightwall == true
            % The fore object is connecting to the right wall
        end
    end

    %% 7. Check the 3D Model of the Scene
    if plot_check_3D_Model==true
        figure
        % drawing lines for background
        % rear wall
        plot3([estimatedVertex(1, 2), estimatedVertex(1, 3)], [estimatedVertex(2, 2), estimatedVertex(2, 3)], [estimatedVertex(3, 2), estimatedVertex(3, 3)], 'b')
hold on
plot3([estimatedVertex(1, 3), estimatedVertex(1, 9)], [estimatedVertex(2, 3), estimatedVertex(2, 9)], [estimatedVertex(3, 3), estimatedVertex(3, 9)], 'b')
plot3([estimatedVertex(1, 9), estimatedVertex(1, 8)], [estimatedVertex(2, 9), estimatedVertex(2, 8)], [estimatedVertex(3, 9), estimatedVertex(3, 8)], 'b')
plot3([estimatedVertex(1, 8), estimatedVertex(1, 2)], [estimatedVertex(2, 8), estimatedVertex(2, 2)], [estimatedVertex(3, 8), estimatedVertex(3, 2)], 'b')
% floor
plot3([estimatedVertex(1, 2), estimatedVertex(1, 4)], [estimatedVertex(2, 2), estimatedVertex(2, 4)], [estimatedVertex(3, 2), estimatedVertex(3, 4)], 'b')
plot3([estimatedVertex(1, 4), estimatedVertex(1, 5)], [estimatedVertex(2, 4), estimatedVertex(2, 5)], [estimatedVertex(3, 4), estimatedVertex(3, 5)], 'b')
plot3([estimatedVertex(1, 5), estimatedVertex(1, 3)], [estimatedVertex(2, 5), estimatedVertex(2, 3)], [estimatedVertex(3, 5), estimatedVertex(3, 3)], 'b')
% left wall
plot3([estimatedVertex(1, 8), estimatedVertex(1, 12)], [estimatedVertex(2, 8), estimatedVertex(2, 12)], [estimatedVertex(3, 8), estimatedVertex(3, 12)], 'b')
plot3([estimatedVertex(1, 6), estimatedVertex(1, 12)], [estimatedVertex(2, 6), estimatedVertex(2, 12)], [estimatedVertex(3, 6), estimatedVertex(3, 12)], 'b')
plot3([estimatedVertex(1, 6), estimatedVertex(1, 2)], [estimatedVertex(2, 6), estimatedVertex(2, 2)], [estimatedVertex(3, 6), estimatedVertex(3, 2)], 'b')
% right wall
plot3([estimatedVertex(1, 13), estimatedVertex(1, 9)], [estimatedVertex(2, 13), estimatedVertex(2, 9)], [estimatedVertex(3, 13), estimatedVertex(3, 9)], 'b')
plot3([estimatedVertex(1, 13), estimatedVertex(1, 7)], [estimatedVertex(2, 13), estimatedVertex(2, 7)], [estimatedVertex(3, 13), estimatedVertex(3, 7)], 'b')
plot3([estimatedVertex(1, 7), estimatedVertex(1, 3)], [estimatedVertex(2, 7), estimatedVertex(2, 3)], [estimatedVertex(3, 7), estimatedVertex(3, 3)], 'b')
% ceiling
plot3([estimatedVertex(1, 8), estimatedVertex(1, 10)], [estimatedVertex(2, 8), estimatedVertex(2, 10)], [estimatedVertex(3, 8), estimatedVertex(3, 10)], 'b')
plot3([estimatedVertex(1, 10), estimatedVertex(1, 11)], [estimatedVertex(2, 10), estimatedVertex(2, 11)], [estimatedVertex(3, 10), estimatedVertex(3, 11)], 'b')
plot3([estimatedVertex(1, 11), estimatedVertex(1, 9)], [estimatedVertex(2, 11), estimatedVertex(2, 9)], [estimatedVertex(3, 11), estimatedVertex(3, 9)], 'b')
if given_foreobj==true
plot3([foreobj_3D(1, 4), foreobj_3D(1, 3)], [foreobj_3D(2, 4), foreobj_3D(2, 3)], [foreobj_3D(3, 4), foreobj_3D(3, 3)], 'r')
plot3([foreobj_3D(1, 3), foreobj_3D(1, 2)], [foreobj_3D(2, 3), foreobj_3D(2, 2)], [foreobj_3D(3, 3), foreobj_3D(3, 2)], 'r')
plot3([foreobj_3D(1, 2), foreobj_3D(1, 1)], [foreobj_3D(2, 2), foreobj_3D(2, 1)], [foreobj_3D(3, 2), foreobj_3D(3, 1)], 'r')
plot3([foreobj_3D(1, 1), foreobj_3D(1, 4)], [foreobj_3D(2, 1), foreobj_3D(2, 4)], [foreobj_3D(3, 1), foreobj_3D(3, 4)], 'r')
end
% Adding highlights and numbers for the Vertices
scatter3(estimatedVertex(1, 1:13), estimatedVertex(2, 1:13), estimatedVertex(3, 1:13), 'g')
for i = 1:13
num = num2str(i - 1);
text(estimatedVertex(1, i), estimatedVertex(2, i), estimatedVertex(3, i), num, 'color', 'red')
end
%%zticks(-3.5:0.1:-1)
% Drawing lines for foreobject (to be implemented)
xlabel('x')
ylabel('y')
zlabel('z')
hold off
    end

   %% 8. Output Required Variables
% Following variables are required by Transformation part.
for i = 2:13
    % calculate the max and min x coordinate in screen coordinate system
    if estimatedVertex_screen_coor(1, i) < min_x_oev
        min_x_oev = estimatedVertex_screen_coor(1, i);
    elseif estimatedVertex_screen_coor(1, i) > max_x_oev
        max_x_oev = estimatedVertex_screen_coor(1, i);
    end
    % calculate the max and min y coordinate in screen coordinate system
    if estimatedVertex_screen_coor(2, i) < min_y_oev
        min_y_oev = estimatedVertex_screen_coor(2, i);
    elseif estimatedVertex_screen_coor(2, i) > max_y_oev
        max_y_oev = estimatedVertex_screen_coor(2, i);
    end
end
diff_x_oev = max_x_oev - min_x_oev;
diff_y_oev = max_y_oev - min_y_oev;

oevminx = min_x_oev;
oevmaxx = max_x_oev;
oevminy = min_y_oev;
oevmaxy = max_y_oev;
oevdiffx = diff_x_oev;
oevdiffy = diff_y_oev;
if given_foreobj==true
    foreObj = [foreobj_3D; foreobj_2D_screen_coor];
end

estimatedVertex(4:5, 1:13) = estimatedVertex_screen_coor;
R = -depth;

end
%% Subfunctions for the Build Foreobject

% when the foreobject is on the floor
function floor_foreobj = Foreobj3DBuild_Floor(foreobj_2D_screen_coor)
global View_Point
floor_foreobj = zeros(3, 4);
for i = 3:4
% weight function
weight = (-1 - View_Point(2)) / (foreobj_2D_screen_coor(2, i) - View_Point(2));
% compute the coordinate for vertices 3,4
floor_foreobj(1, i) = weight * (foreobj_2D_screen_coor(1, i) - View_Point(1)) + View_Point(1);
floor_foreobj(2, i) = -1;
floor_foreobj(3, i) = weight * (-1 - View_Point(3)) + View_Point(3);
end

% some parameters
hight_obj = (foreobj_2D_screen_coor(2, 1) - foreobj_2D_screen_coor(2, 4)) * -floor_foreobj(3, 3);
top_obj = -1 + hight_obj;
depth_obj = floor_foreobj(3, 3);

% for 1
floor_foreobj(1, 1) = floor_foreobj(1, 4);
floor_foreobj(2, 1) = top_obj;
floor_foreobj(3, 1) = depth_obj;

% for 2
floor_foreobj(1, 2) = floor_foreobj(1, 3);
floor_foreobj(2, 2) = top_obj;
floor_foreobj(3, 2) = depth_obj;

end

% when the foreobject is on the ceiling
function ceiling_foreobj = Foreobj3DBuild_Ceiliing(foreobj_2D_screen_coor, y_ceiling)
if exist("y_ceiling") == 0 %#ok
error("For the calculation of the foreobject on the ceiling in world coordinate system, " + ...
"you have to enter the y coordinate of the background ceiling while calling the function " + ...
"Foreobj3DBuild_Ceiling")
end

global View_Point
ceiling_foreobj = zeros(3, 4);

for i = 1:2
    % weight function
    weight = (1 - View_Point(2)) / (foreobj_2D_screen_coor(2, i) - View_Point(2));
    % compute the coordinates of 1,2
    ceiling_foreobj(1, i) = weight * (foreobj_2D_screen_coor(1, i) - View_Point(1)) + View_Point(1);
    ceiling_foreobj(2, i) = y_ceiling;
    ceiling_foreobj(3, i) = weight * (-1 - View_Point(3)) + View_Point(3);
end

% some parameters
hight_obj = (foreobj_2D_screen_coor(2, 1) - foreobj_2D_screen_coor(2, 4)) * -ceiling_foreobj(3, 1);
bottom_obj = ceiling_foreobj(2, 1) - hight_obj;
depth_obj = ceiling_foreobj(3, 1);

% for 3
ceiling_foreobj(1, 3) = ceiling_foreobj(1, 2);
ceiling_foreobj(2, 3) = bottom_obj;
ceiling_foreobj(3, 3) = depth_obj;

% for 4
ceiling_foreobj(1, 4) = ceiling_foreobj(1, 1);
ceiling_foreobj(2, 4) = bottom_obj;
ceiling_foreobj(3, 4) = depth_obj;

end
