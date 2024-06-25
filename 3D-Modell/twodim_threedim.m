function  P3D = twodim_threedim(x_v, y_v, x, y)

    f = 1;  
    K = [f, 0, x_v; 
         0, f, y_v; 
         0, 0, 1];

    depth = f / max(abs(x - x_v), abs(y - y_v));

    P2D_hom = [x; y; 1];
   

     P3D_hom = K \ P2D_hom;


   P3D = [P3D_hom(1) * depth, P3D_hom(2) * depth, depth];
end