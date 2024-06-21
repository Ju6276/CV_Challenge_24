function [twelfPoints_3D,Vanishing_point_3D] = bg_3Dmod(corners,k)
% 将12个2维座标点的坐标转化为12个3维座标点的坐标
% Convert the coordinates of 12 two-dimensional
% points into coordinates of 12 three-dimensional points.

    % extract 2D coordinates of the Twelf points
    P1 = corners(1,:);
    P2 = corners(2,:);
    P3 = corners(3,:);
    P4 = corners(4,:);
    P5 = corners(5,:);
    P6 = corners(6,:);
    P7 = corners(7,:);
    P8 = corners(8,:);
    P9 = corners(9,:);
    P10 = corners(10,:);
    P11 = corners(11,:);
    P12 = corners(12,:);
    
    %v extract vanishing point
    x_v = vp(1);
    y_v = vp(2);


    % get the 3D coordinates of the vanishing point    
    Vanishing_point_3D = twodim_threedim(x_v,y_v,vp(1),vp(2));

    % get the 3D coordinates of the 12 points
    % P1--2D, p1--3D
    p1 = twodim_threedim(x_v,y_v,P1(1), P1(2));
    p2 = twodim_threedim(x_v,y_v,P2(1), P2(2));
    p3 = twodim_threedim(x_v,y_v,P3(1), P3(2));
    p4 = twodim_threedim(x_v,y_v,P4(1), P4(2));
    p5 = twodim_threedim(x_v,y_v,P5(1), P5(2));
    p6 = twodim_threedim(x_v,y_v,P6(1), P6(2));
    p7 = twodim_threedim(x_v,y_v,P7(1), P7(2));
    p8 = twodim_threedim(x_v,y_v,P8(1), P8(2));
    p9 = twodim_threedim(x_v,y_v,P9(1), P9(2));
    p10 = twodim_threedim(x_v,y_v,P10(1), P10(2));
    p11 = twodim_threedim(x_v,y_v,P11(1), P11(2));
    p12 = twodim_threedim(x_v,y_v,P12(1), P12(2));

    % define the paremeter of the 5 plane
    % calculate 3D coordinates of the floor
    floor = p1(2);
    p3 = p3/p3(2) * floor;
    p4 = p4/p4(2) * floor;
    p5 = p5/p5(2) * floor;
    p6 = p6/p6(2) * floor;

    % calculate 3D coordinates of the ceiling
    ceiling = p7(2);
    p9 = p9/p9(2) * ceiling;
    p10 = p10/p10(2) * ceiling;
    p11 = p11/p11(2) * ceiling;
    p12 = p12/p12(2) * ceiling;

    % calculate 3D coordinates of the right wall
    rw = p8(1);

     % calculate 3D coordinates of the left wall
    lw = p7(1);

    % determine the points on the walls by normalizing
    % 将一个二维像素坐标 P3(1), P3(2) 转换为相机内部校准后的三维坐标
    % 然后对其进行归一化和缩放操作   

    Vanishing_point_3D(3) = Vanishing_point_3D(3) * k;
    p1(3) = p1(3) * k;
    p2(3) = p2(3) * k;
    p3(3) = p3(3) * k;
    p4(3) = p4(3) * k;
    p5(3) = p5(3) * k;
    p6(3) = p6(3) * k;
    p7(3) = p7(3) * k;
    p8(3) = p8(3) * k;
    p9(3) = p9(3) * k;
    p10(3) = p10(3) * k;
    p11(3) = p11(3) * k;
    p12(3) = p12(3) * k;

    %output the 3D positon of the 12 points

    twelfPoints_3D = [p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12];

end
