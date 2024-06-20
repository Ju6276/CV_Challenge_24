function P3D_with_hom = twodim_threedim(x_v,y_v,x,y)
% [x_v,y_v] is the pixel coordination of the vanishing point
% where u_v represents x coordinate, v_v is represents the y coordinate
% slide chap.2.4 transform of image coordinates to pixel coordinates
% function'twodim_threedim' transform a 2D coordinates into a 3D coordinates
% x and y are pixel coordinats of a 2D point 

stheta = 0; % the angle between axis-z and plane-x
s_x = 1;% define the length unit
s_y = 1; 
o_x = x_v; % from uncalibration to calibration
o_y = y_v;
K_s = [s_x, stheta, o_x; 0, s_y, o_y; 0, 0, 1];

% define focal length matrix K_f
f = 1;
K_f = [f,0,0; 0, f, 0; 0, 0,1];

% define the calibration matrix K
K = K_s * K_f; 

P3D_with_hom =K\[x,y,1]';
end



