function Show3DModel(Location,Target_Position,VanishingPoint_3D,Camera_Position)
    % initial settings
    v = [0,0,-1];
    view(Location,v);
    
    camproj(Location,'perspective');
    camva(Location,'manual');
    
    camva(Location,90);
    camup(Location,[0,1,0]);
   
    %camera position
    campos(Location,Camera_Position);
    
    %target position
    camtarget(Location,[Target_Position(1),Target_Position(2),VanishingPoint_3D(3)]);
    drawnow;
    Location.Position = [270 109 929 564];
    Location.XLimMode ="auto";
    Location.YLimMode ="auto";
    Location.ZLimMode ="auto";
    % axis(ax,'equal');
    % axis(ax,'vis3d','off');
end

