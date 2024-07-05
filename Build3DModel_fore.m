function [out, output_vertices,fore_output_vertices] = Build3DModel_fore(points, img, foreground2DCoordinates, forePos)
    out = 0;

    %%% Variable declaration
    % Input global variables
    global input_img
    global vanishingpoint_x vanishingpoint_y
    global screen_coordinatesX screen_coordinatesY foreground2DCoordinates     
    
    % Output global variables
    global R output_vertices minXScreen maxXScreen minYScreen maxYScreen
    global view_point fore_output_vertices screenWidth screenHeight
    given_foreobj=true;
   
    % Initialize some variables
    %on_floor=true;

    % Assign points to global variables
    vanishingpoint_x = points(13, 1);
    vanishingpoint_y = points(13, 2);
    screen_coordinatesX = points(1:12, 1)';
    screen_coordinatesY = points(1:12, 2)';
    input_img = img;
    size_input_img = size(img);



    output_vertices_pixel_coor = zeros(2, 13);
    output_vertices_pixel_coor(1, 1:13) = [vanishingpoint_x, screen_coordinatesX]; 
    output_vertices_pixel_coor(2, 1:13) = [vanishingpoint_y, screen_coordinatesY];

    
    minX = 0;
    maxX = 0;
    minY = 0;
    maxY = 0;

    % change the coordinates for background 
    output_vertices_screen_coor = normalize_coor(output_vertices_pixel_coor, size_input_img);    
  
    % change the coordinates for foreground
    fore_screen = zeros(2, 4);
    if given_foreobj==true
        % translate the ponints position from pixel coordinate to screen coordinates 
        % choose the central point of the image as the original point in screen coordinates
        % translate x- & y-axis, flip y-axis over
        % we do the same to foreobject
       fore_screen(1,1:4) = foreground2DCoordinates(1,1:4)-(size_input_img(2)+1)/2;
       fore_screen(2,1:4) = -(foreground2DCoordinates(2,1:4)-(size_input_img(1)+1)/2);
       %  % normalization, to build the new border of the screeen coordinates
       % x in [-1, 1], y in [-1,1]
       fore_screen(1,1:4) = fore_screen(1,1:4)./((size_input_img(2)-1)/2);
       fore_screen(2,1:4) = fore_screen(2,1:4)./((size_input_img(1)-1)/2);
    end 


    % Define the position of View Point in World Coordinate System
    view_point = [output_vertices_screen_coor(1, 1), output_vertices_screen_coor(2, 1), 0];
    disp('View point is')
    disp(view_point)

 
    % reconstruct 3D coordinates of 13 points
    % for the points in floor (1,2,3,4,5,6), y=-1
    for i = 2:7
        % The objects near the viewer will be visually larger. For that we define a proper "weight function".
        weight_floor = -(1 + view_point(2)) / (output_vertices_screen_coor(2, i) - view_point(2));
        % xyz for points 1 2 3 4 5 6
        output_vertices(1, i) = weight_floor * (output_vertices_screen_coor(1, i) - view_point(1)) + view_point(1);
        output_vertices(2, i) = -1;
        output_vertices(3, i) = weight_floor * (-1 - view_point(3)) + view_point(3);
    end

    % Relocate the vanishing point, the value of z 
    % should be the same with point 1
    output_vertices(1:2, 1) = output_vertices_screen_coor(1:2, 1);
    output_vertices(3, 1) = output_vertices(3, 2);

    % calculate the height of the box, it equal to the y-difference between
    % point 7 and point 1 and the depth
    height = (output_vertices_screen_coor(2, 8) - output_vertices_screen_coor(2, 2)) * -output_vertices(3, 1);
    % y axis beginn with -1
    y_ceiling = height - 1;
    % the value x of leftwall is the same with point 1
    x_left_wall = output_vertices(1, 2);
    % the value x of rightwall is the same with point 2
    x_right_wall = output_vertices(1, 3);
    % the depth of rearwall is the same with z value of vanishing point
    depth = output_vertices(3, 1);

    % points(1,2,7,8) on rear wall, the position of point 1 & 2 are known
    % for point 7 & 8
    output_vertices(1:3, 8) = [x_left_wall; y_ceiling; depth];
    output_vertices(1:3, 9) = [x_right_wall; y_ceiling; depth];

    % points(9,10,11,12) on ceiling wall
    for i = 10:13
        % like points 1-6, we also need a weight function
        weight_ceiling = (height - 1 - view_point(2)) / (output_vertices_screen_coor(2, i) - view_point(2));
        % get xyz for points 9, 10, 11, 12
        output_vertices(1, i) = weight_ceiling * (output_vertices_screen_coor(1, i) - view_point(1)) + view_point(1);
        output_vertices(2, i) = y_ceiling;
        output_vertices(3, i) = weight_ceiling * (-1 - view_point(3)) + view_point(3);
    end   


    % reconstruct 3D coordinates of foreground points
    % check the foreground in which plane of the space
     if forePos =="on_floor" 
         fore_output_vertices = fore3D_floor(fore_screen);
     elseif forePos =="on_ceiling"
         fore_output_vertices = fore3D_ceiling(fore_screen,y_ceiling);
     elseif forePos =="on_leftwall" 
         fore_output_vertices = fore3D_leftwall(fore_screen,x_left_wall);
     elseif forePos =="on_rightwall"
         fore_output_vertices = fore3D_rightwall(fore_screen,x_right_wall);
     end


    
   %  % plot the 3D background model of the scene
   % plot_check_3D_dodel=true;
   %  if plot_check_3D_dodel
   %      plot3DModel(location, output_vertices, given_foreobj, fore_output_vertices );
   %  end
   % 
   %  % plot the 3D construction of the foreground
   
   if given_foreobj==true
        plot3(location,[fore_output_vertices(1, 4), fore_output_vertices(1, 3)], [fore_output_vertices(2, 4), fore_output_vertices(2, 3)], [fore_output_vertices(3, 4), fore_output_vertices(3, 3)], 'r')
        plot3(location,[fore_output_vertices(1, 3), fore_output_vertices(1, 2)], [fore_output_vertices(2, 3),fore_output_vertices(2, 2)], [fore_output_vertices(3, 3), fore_output_vertices(3, 2)], 'r')
        plot3(location,[fore_output_vertices(1, 2), fore_output_vertices(1, 1)], [fore_output_vertices(2, 2), fore_output_vertices(2, 1)], [fore_output_vertices(3, 2), fore_output_vertices(3, 1)], 'r')
        plot3(location,[fore_output_vertices(1, 1), fore_output_vertices(1, 4)], [fore_output_vertices(2, 1), fore_output_vertices(2, 4)], [fore_output_vertices(3, 1), fore_output_vertices(3, 4)], 'r')
    end
    
    
    %  Output Required Variables
    % Following variables are required by Transformation part.
    for i = 2:13
        % calculate the max and min x coordinate in screen coordinate system
        if output_vertices_screen_coor(1, i) < minX
            minX = output_vertices_screen_coor(1, i);
        elseif output_vertices_screen_coor(1, i) > maxX
            maxX = output_vertices_screen_coor(1, i);
        end
         
        % calculate the max and min y coordinate in screen coordinate system
        if output_vertices_screen_coor(2, i) < minY
            minY = output_vertices_screen_coor(2, i);
        elseif output_vertices_screen_coor(2, i) > maxY
            maxY = output_vertices_screen_coor(2, i);
        end
    
    end

    diff_x_oev = maxX - minX;
    diff_y_oev = maxY - minY;

    minXScreen = minX;
    maxXScreen = maxX;
    minYScreen = minY;
    maxYScreen = maxY;
    screenWidth = diff_x_oev;
    screenHeight = diff_y_oev;


    output_vertices(4:5, 1:13) = output_vertices_screen_coor;
    R = -depth;

end



%% Subfunction
 
function output_vertices_screen_coor = normalize_coor(output_vertices_pixel_coor, size_input_img)
 % translate the ponints position from pixel coordinate to screen coordinates 
    % choose the center point of the image as the original point in screen coordinates
    % translate x- & y-axis, flip y-axis over
    % normalization, to build the new border of the screeen coordinates
    % x in [-1, 1], y in [-1,1]
    output_vertices_screen_coor = [(output_vertices_pixel_coor(1,:)-(size_input_img(2)+1)/2)/((size_input_img(2)-1)/2);...
                                  -(output_vertices_pixel_coor(2,:) - (size_input_img(1)+1)/2)/((size_input_img(1)-1)/2)];
end


% when the foreground on the floor
function fore_on_floor = fore3D_floor(fore_screen)

   global view_point

   fore_on_floor = zeros(3,4);
   % if the foreground is on the floor plane, the y value of points 3 and 4 in
   % foreground should be -1
   for i = 3:4
       % weight function
       weight = (-1-view_point(2))/(fore_screen(2,i)-view_point(2));
       % compute the coordinate for vertices 3,4
       fore_on_floor(1,i) = weight*(fore_screen(1,i)-view_point(1))+view_point(1);
       fore_on_floor(2,i) = -1;
       fore_on_floor(3,i) = weight*(-1-view_point(3))+view_point(3);% fore_on_floor(3,i) = weight*(-1-view_point(3))+view_point(3);
   end

   % some parameters
   hight_obj = (fore_screen(2,1)-fore_screen(2,4))*-fore_on_floor(3,3);
   top_obj = -1+hight_obj;
   depth_obj = fore_on_floor(3,3);

   % for point 1
   fore_on_floor(1,1) = fore_on_floor(1,4);
   fore_on_floor(2,1) = top_obj;
   fore_on_floor(3,1) = depth_obj;

   % for point 2
   fore_on_floor(1,2) = fore_on_floor(1,3);
   fore_on_floor(2,2) = top_obj;
   fore_on_floor(3,2) = depth_obj;

end




% when the foreground on the ceiling
function fore_on_ceiling = fore3D_ceiling(fore_screen,y_ceiling)

    global view_point

    fore_on_ceiling = zeros(3,4);
    % if the foreground is on the ceiling plane, the y value of points 1 and 2 in
    % foreground should be +1
    for i = 1:2
       % weight function
       weight = (1-view_point(2))/(fore_screen(2,i)-view_point(2));
       % compute the coordinate for vertices 1,2
       fore_on_ceiling(1,i) = weight*(fore_screen(1,i)-view_point(1))+view_point(1);
       fore_on_ceiling(2,i) = y_ceiling;
       fore_on_ceiling(3,i) = weight*(-1-view_point(3))+view_point(3);
    end

    % some parameters
    hight_obj = (fore_screen(2,1)-fore_screen(2,4))*-fore_on_ceiling(3,1);
    bottom_obj = fore_on_ceiling(2,1) - hight_obj;
    depth_obj = fore_on_ceiling(3,1);

    % for point 3
    fore_on_ceiling(1,3) = fore_on_ceiling(1,2);
    fore_on_ceiling(2,3) = bottom_obj;
    fore_on_ceiling(3,3) = depth_obj;

    % for point 4
    fore_on_ceiling(1,4) = fore_on_ceiling(1,1);
    fore_on_ceiling(2,4) = bottom_obj;
    fore_on_ceiling(3,4) = depth_obj;

end
 


% when the foreground on the leftwall
function fore_on_leftwall = fore3D_leftwall(fore_screen,x_left_wall)

    global view_point

    fore_on_leftwall = zeros(3,4);
    % if the foreground is on the leftwall plane, the x value of points 1 and 4 in
    % foreground should be -1
    
       % weight function
       weight1 = (-1-view_point(1))/(fore_screen(1,1)-view_point(1));
       % compute the coordinate for vertices 1,4
       fore_on_leftwall(1,1) = x_left_wall;       
       fore_on_leftwall(2,1) = weight1*(fore_screen(2,1)-view_point(2))+view_point(2);
       fore_on_leftwall(3,1) = weight1*(-1-view_point(3))+view_point(3);

       % weight function
       weight2 = (-1-view_point(1))/(fore_screen(1,4)-view_point(1));
       % compute the coordinate for vertices 3,4
       fore_on_leftwall(1,4) = x_left_wall;
       fore_on_leftwall(2,4) = weight2*(fore_screen(2,4)-view_point(2))+view_point(2);
       fore_on_leftwall(3,4) = weight2*(-1-view_point(3))+view_point(3);
    

       % some parameters
       width_obj = (fore_screen(1,1)-fore_screen(1,2))*-fore_on_leftwall(3,1);
       right_obj = fore_on_leftwall(1,1) + width_obj;
       depth_obj = fore_on_leftwall(3,1);

       % for point 2
       fore_on_leftwall(1,2) = right_obj;
       fore_on_leftwall(2,2) = fore_on_leftwall(2,1);
       fore_on_leftwall(3,2) = depth_obj;

       % for point 3
       fore_on_leftwall(1,3) = right_obj;
       fore_on_leftwall(2,3) = fore_on_leftwall(2,4);
       fore_on_leftwall(3,3) = depth_obj;

end


  
% when the foreground on the  rightwall
function fore_on_rightwall = fore3D_rightwall(fore_screen)

    global view_point

    fore_on_rightwall = zeros(3,4);
    % if the foreground is on the rightwall plane, the x value of points 2 and 3 in
    % foreground should be +1
    
       
       for i= 2:3
           % weight function
           weight = (1-view_point(1))/(fore_screen(1,i)-view_point(1));
           % compute the coordinate for vertices 2,3
           fore_on_rightwall(1,i) = x_right_wall;       
           fore_on_rightwall(2,i) = weight*(fore_screen(2,i)-view_point(2))+view_point(2);
           fore_on_rightwall(3,i) = weight*(-1-view_point(3))+view_point(3);
       end
       
       % some parameters
       width_obj = (fore_screen(1,1)-fore_screen(1,2))*-fore_on_rightwall(3,2);
       left_obj = fore_on_rightwall(1,2) - width_obj;
       depth_obj = fore_on_rightwall(3,2);

       % for point 1
       fore_on_rightwall(1,1) = left_obj;
       fore_on_rightwall(2,1) = fore_on_rightwall(2,2);
       fore_on_rightwall(3,1) = depth_obj;

       % for point 4
       fore_on_rightwall(1,4) = left_obj;
       fore_on_rightwall(2,4) = fore_on_ceiling(2,3);
       fore_on_rightwall(3,4) = depth_obj;

end    






    
function plot3DModel(location, output_vertices)
    hold(location, 'on');

    % drwa the line of the background
    plot3Lines(location, output_vertices, [
        2 3; 3 9; 9 8; 8 2; % rear wall
        2 4; 4 5; 5 3; % floor
        8 12; 6 12; 6 2; % left wall
        13 9; 13 7; 7 3; % right wall
        8 10; 10 11; 11 9 % ceiling
    ], 'b');



   
    % Adding highlights and numbers for the Vertices
    scatter3(location, output_vertices(1, :), output_vertices(2, :), output_vertices(3, :), 'g')
    for i = 1:13
        text(location, output_vertices(1, i), output_vertices(2, i), output_vertices(3, i), num2str(i - 1), 'color', 'red');
    end
end



  

