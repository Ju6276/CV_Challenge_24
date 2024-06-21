function points = Selection()
    
%load picture
    [fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
    if isequal(fileName, 0)
        disp('User selected Cancel');
        points = []; % Return an empty array if user cancels
        return;
    else
        imagePath = fullfile(pathName, fileName);
        img = imread(imagePath);
    end


    figure, imshow(img), hold on;
    
    % Vanishpoint
    disp('Click to select the vanishing point.');
    vanishingPoint = drawpoint('Color', 'yellow'); 
    wait(vanishingPoint);
    text(vanishingPoint.Position(1), vanishingPoint.Position(2), '0', 'Color', 'yellow', 'FontSize', 20, 'FontWeight', 'bold');
    
  
    points = zeros(13, 2);
    points(13, :) = vanishingPoint.Position;

    % Background
    disp('Now draw the rectangle.');
    innerRectangle = drawrectangle('Color', 'b', 'LineWidth', 4);
    wait(innerRectangle);

    
    corners = [innerRectangle.Position(1), innerRectangle.Position(2); 
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2);
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2) + innerRectangle.Position(4);
               innerRectangle.Position(1), innerRectangle.Position(2) + innerRectangle.Position(4)];
    
 
    labels = [7, 8, 2, 1];
    for i = 1:4
        points(labels(i), :) = corners(i, :);
        text(corners(i, 1), corners(i, 2), num2str(labels(i)), 'Color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');
    end
    

    
    for i = 1:4
        
         % left right points( 11 5 6 12)
         [xw, yw] = LeftRightPoints(vanishingPoint.Position, corners(i, :), size(img),labels(i));
        
         if ~isempty(xw) && ~isempty(yw)
           
            points(labels(i)+4, :) = [xw, yw];
            
           
            line([vanishingPoint.Position(1), xw], [vanishingPoint.Position(2), yw], 'Color', 'b', 'LineWidth', 4);
            plot(xw, yw, 'ro'); 
            text(xw, yw, num2str(labels(i)+4), 'Color', 'magenta', 'FontSize', 20, 'FontWeight', 'bold');
         end 
           
            
            % top bottom points(9 10 3 4)
            [xh, yh] = TopBottomPoints(vanishingPoint.Position, corners(i, :), size(img),labels(i));
           
         if ~isempty(xh) && ~isempty(yh)
              
             points(labels(i)+2, :) = [xh, yh];
                
             line([vanishingPoint.Position(1), xh], [vanishingPoint.Position(2), yh], 'Color', 'b', 'LineWidth', 4);
             plot(xh, yh, 'bs'); 
             text(xh, yh, num2str(labels(i)+2), 'Color', 'cyan', 'FontSize', 20, 'FontWeight', 'bold');
          end
        
    end
    
    line([points(3,1), points(4,1)], [points(3,2), points(4,2)], 'Color', 'b', 'LineWidth', 4);
    line([points(9,1), points(10,1)], [points(9,2), points(10,2)], 'Color', 'b', 'LineWidth', 4);
    line([points(5,1), points(11,1)], [points(5,2), points(11,2)], 'Color', 'b', 'LineWidth', 4);
    line([points(6,1), points(12,1)], [points(6,2), points(12,2)], 'Color', 'b', 'LineWidth', 4);

    disp('Stored Points:');
    disp(points);
end


function [xw, yw] = LeftRightPoints(vp, corner, imgSize,labels)
    
    dx = vp(1)-corner(1);
    dy = vp(2)-corner(2);
 
    xw = [];
    yw = [];
    
    if  ~isempty(labels) && (labels == 1 || labels == 7) %left
        imgSize(2)=0;
    end

    yw = dy/dx*(imgSize(2)-vp(1))+vp(2);
    xw=imgSize(2);
   
end


function [xh, yh] = TopBottomPoints(vp, corner, imgSize,labels)
    
    dx = vp(1)-corner(1);
    dy = vp(2)-corner(2);
  
    xh = [];
    yh = [];
    
    if  ~isempty(labels) && (labels == 7 || labels == 8) %top
        imgSize(1)=0;
    end

    xh = dx/dy*(imgSize(1)-vp(2))+vp(1);
    yh=imgSize(1);
    
end


