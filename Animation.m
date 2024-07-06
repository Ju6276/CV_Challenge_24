function Animation(location,VanishingPoint_3D,estimatedVertex)
    %% animation
    
    
    Center_Point = [(estimatedVertex(1,1)+estimatedVertex(1,2))/2,(estimatedVertex(2,1)+estimatedVertex(2,7))/2];
    
    x_bound = abs((estimatedVertex(1,1)-estimatedVertex(1,2))/2)*0.6;
    y_bound = abs((estimatedVertex(2,7)-estimatedVertex(2,1))/2)*0.6;
    
    z_lbound = min(estimatedVertex(3,3),estimatedVertex(3,5))/3;
    z_hbound = VanishingPoint_3D(3)*0.55;
    
    camva(location,90);
    camtarget(location,[Center_Point(1),Center_Point(2),VanishingPoint_3D(3)]);
 
    % go in
    for z = z_lbound:-0.02:z_hbound
    campos(location,[Center_Point(1),Center_Point(2),z])
    drawnow
    pause(.1)
    end

    %turn left
    for x = 0:-0.02:-x_bound
        campos(location,[Center_Point(1),Center_Point(2),z_hbound])
        camtarget(location,[Center_Point(1)-x,Center_Point(2),VanishingPoint_3D(3)])
        drawnow
        pause(.1)
    end
   % turn right
    for x = -x_bound:0.02:x_bound
        campos(location,[Center_Point(1),Center_Point(2),z_hbound])
        camtarget(location,[Center_Point(1)-x,Center_Point(2),VanishingPoint_3D(3)])
        drawnow
        pause(.1)
    end
   % from right back
    for x = x_bound:-0.02:0
        campos(location,[Center_Point(1),Center_Point(2),z_hbound])
        camtarget(location,[Center_Point(1)-x,Center_Point(2),VanishingPoint_3D(3)])
        drawnow
        pause(.1)
    end
    
   
    % look up
    for y = 0:0.02:y_bound
        campos(location,[Center_Point(1),Center_Point(2)-y,z_hbound])
        drawnow
        pause(.1)
    end
    % look down    
    for y = y_bound:-0.02:-y_bound
        campos(location,[Center_Point(1),Center_Point(2)-y,z_hbound])
        drawnow
        pause(.1)
    end
    % look from down back    
    for y = -y_bound:-0.02:0
        campos(location,[Center_Point(1),Center_Point(2)-y,z_hbound])
        drawnow
        pause(.1)
    end

    %go out
    for z = z_hbound:0.02:z_lbound
        campos(location,[Center_Point(1),Center_Point(2),z])
        drawnow
        pause(.1)
    end
end
