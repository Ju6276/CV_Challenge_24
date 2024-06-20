 % build four lines cross the vanishing point and 
    % the corners of inner rectangle
    % the line directed to top left(tl)
    dx_tl = corners(1,1) - vp(1);
    dy_tl = corners(1,2) - vp(2);

   
    if dx_tl == 0
        error('The vanishing point and the corner point have the same x-coordinate, resulting in a vertical line.');
    end
    % calculate the slope
    k_tl = dy_tl / dx_tl;
    
    % the line directed to bottom left(bl)
    dx_bl = corners(4,1) - vp(1);
    dy_bl = corners(4,2) - vp(2);
    if dx_bl == 0
        error('The vanishing point and the corner point have the same x-coordinate, resulting in a vertical line.');
    end
    % calculate the slope
    k_bl = dy_bl / dx_bl;

    % the line directed to top right(tr)
    dx_tr = corners(2,1) - vp(1);
    dy_tr = corners(2,2) - vp(2);
    if dx_tr == 0
        error('The vanishing point and the corner point have the same x-coordinate, resulting in a vertical line.');
    end
    % calculate the slope
    k_tr = dy_tr / dx_tr;

    % the line directed to bottom right(br)
    dx_br = corners(3,1) - vp(1);
    dy_br = corners(3,2) - vp(2);
    if dx_br == 0
        error('The vanishing point and the corner point have the same x-coordinate, resulting in a vertical line.');
    end
    % calculate the slope
    k_br = dy_br / dx_br;
    


    % determine the outter eight points of intersection
    % two points in y=0
    %in top left
    x_y0tl= (1/k_tl) * (0 - vp(2)) + vp(1);
    y_y0tl = 0;
    % in bottom left
    x_y0bl= (1/k_bl) * (0 - vp(2)) + vp(1);
    y_y0bl = 0;
    %intersection in y = 0
    inter_y0 = [x_y0tl, 0; x_y0bl,0];


    % two points in x=0
    % in top left
    x_x0tl= 0;
    y_x0tl= k_bl *(0 - vp(1)) + vp(2);
    % in top right
    x_x0tr= 0;
    y_x0tr= k_tr *(0 - vp(1)) + vp(2);
    %intersection in x = 0
    inter_x0 = [0, y_x0tl; 0, y_x0tr ];
  


    % two points in y=imgSize(2)
    % in top right
    y_max = imgSize(2); 
    y_ymax_tr = y_max;
    x_ymax_tr= (1/k_tr) * (y_ymax_tr - vp(2)) + vp(1);
    % in bottom right
    y_ymax_br = y_max;
    x_ymax_br= (1/k_br) * (y_ymax_br - vp(2)) + vp(1);
    %intersection in y = imgSize(2)
    inter_ymax = [x_ymax_tr,y_ymax_tr; x_ymax_br,y_ymax_br ];


    % two points in x=imgSize(1)
    % in bottom right
    x_max = imgSize(1); 
    x_xmax_br= x_max;
    y_xmax_br= k_br *( x_xmax_br- vp(1)) + vp(2);
    % in bottom left
    x_xmax_bl= x_max;
    y_xmax_bl =k_bl *(x_xmax_bl - vp(1)) + vp(2) ;
    %intersection in y = imgSize(2)
    inter_xmax = [x_xmax_br, y_xmax_br; x_xmax_bl,y_xmax_bl];

    outter_inter = [inter_y0; inter_x0; inter_ymax; inter_xmax];