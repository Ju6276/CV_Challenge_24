function points = Selection(picture,location)
    
%load picture
    % [fileName, pathName] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
    % if isequal(fileName, 0)
    %     disp('User selected Cancel');
    %     points = []; % Return an empty array if user cancels
    %     return;
    % else
    %     imagePath = fullfile(pathName, fileName);
    %     img = imread(imagePath);
    % end

    
    %figure, imshow(picture), hold on;
    imshow(picture,'Parent',location);
    hold(location,"on");
    
    % Vanishpointdrawpoint	
    disp('Click to select the vanishing point.');
     [a, b,~] =size(picture);
     pos_VanishingPoint = [0.5*a, 0.5*b];
    location.XLim = [0 b];
    location.YLim = [0 a];
    location.YDir = 'reverse'; % 反转Y轴，使(0,0)在左上角
    %vanishingPoint = pos_VanishingPoint; 
    %hold(location,"on");'Position',pos_VanishingPoint,
    vanishingPoint = drawpoint(location,'Position',pos_VanishingPoint,'Color', 'yellow','LineWidth', 4);
    vanishingPoint.Label ='Vanish Point';
    hold(location,"on");
    wait(vanishingPoint);
    % vanishingPoint.Visible ="off";
    % plot(location, vanishingPoint.Position);
    %hold(location,"on");
    vanishingPoint.Label = '';
    text(location,vanishingPoint.Position(1), vanishingPoint.Position(2), 'Vanish Point', 'Color', "yellow", 'FontSize', 22, 'FontWeight', 'bold');
    % hold(location,"on");
  
    points = zeros(13, 2);
    points(13, :) = vanishingPoint.Position;

    % Background
    disp('Now draw the rectangle.');
    pos_InnerRectangle = [0.5 * a, 0.5 * b, 0.5 * a + 0.5 * b, 0.5 * a];
    innerRectangle = drawrectangle(location,'Position',pos_InnerRectangle,'Color', [0.4660 0.6740 0.1880], 'LineWidth', 2);
    innerRectangle.Label = 'Background';
    hold(location,"on");
    wait(innerRectangle);
    innerRectangle.Label = '';
    text(location,innerRectangle.Position(1)+ 0.3*innerRectangle.Position(3), innerRectangle.Position(2)+ 0.3*innerRectangle.Position(4), 'Background', 'Color', "g", 'FontSize', 22, 'FontWeight', 'bold');

    
    corners = [innerRectangle.Position(1), innerRectangle.Position(2); 
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2);
               innerRectangle.Position(1) + innerRectangle.Position(3), innerRectangle.Position(2) + innerRectangle.Position(4);
               innerRectangle.Position(1), innerRectangle.Position(2) + innerRectangle.Position(4)];
    
 
    labels = [7, 8, 2, 1];
    for i = 1:4
        points(labels(i), :) = corners(i, :);
        %text(location,corners(i, 1), corners(i, 2), num2str(labels(i)), 'Color', 'blue', 'FontSize', 20, 'FontWeight', 'bold');
        hold(location,"on");
    end
    

    
    for i = 1:4
        
         % left right points( 11 5 6 12)
         [xw, yw] = LeftRightPoints(vanishingPoint.Position, corners(i, :), size(picture),labels(i));
        
         if ~isempty(xw) && ~isempty(yw)
           
            points(labels(i)+4, :) = [xw, yw];
            
           
            line(location,[vanishingPoint.Position(1), xw], [vanishingPoint.Position(2), yw], 'Color', 'b', 'LineWidth', 2);
            hold(location,"on");
            %plot(location,xw, yw, 'ro'); 
            hold(location,"on");
            %text(location,xw, yw, num2str(labels(i)+4), 'Color', 'magenta', 'FontSize', 20, 'FontWeight', 'bold');
            hold(location,"on");
         end 
           
            
            % top bottom points(9 10 3 4)
            [xh, yh] = TopBottomPoints(vanishingPoint.Position, corners(i, :), size(picture),labels(i));
           
         if ~isempty(xh) && ~isempty(yh)
              
             points(labels(i)+2, :) = [xh, yh];
                
             line(location,[vanishingPoint.Position(1), xh], [vanishingPoint.Position(2), yh], 'Color', 'b', 'LineWidth', 2);
             hold(location,"on");
             %plot(location,xh, yh, 'bs'); 
             hold(location,"on");
             %text(location,xh, yh, num2str(labels(i)+2), 'Color', 'cyan', 'FontSize', 20, 'FontWeight', 'bold');
          end
        
    end
    
    line(location,[points(3,1), points(4,1)], [points(3,2), points(4,2)], 'Color', 'b', 'LineWidth', 2);
    hold(location,"on");
    line(location,[points(9,1), points(10,1)], [points(9,2), points(10,2)], 'Color', 'b', 'LineWidth', 2);
    hold(location,"on");
    line(location,[points(5,1), points(11,1)], [points(5,2), points(11,2)], 'Color', 'b', 'LineWidth', 2);
    hold(location,"on");
    line(location,[points(6,1), points(12,1)], [points(6,2), points(12,2)], 'Color', 'b', 'LineWidth', 2);
    hold(location,"on");

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


