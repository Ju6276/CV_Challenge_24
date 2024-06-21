function seperate_walls(corners)
% seperate the background into 5 parts

  % Define the 2D coordinates of the points
  vertex = corners;
   

  % Define the connections between points as shown in the image
  connections = [
    5, 3;   % Red lines
    3, 1;   % Red lines
    11, 9;  % Green lines
    9, 7;   % Green lines
    12, 10; % Black lines
    8, 12;  % Black lines
    2, 6 ;  % Pink lines
    4, 6;   % Pink lines
    3, 4;   % blue lines
    5, 11;   % Yellow lines
    9, 10;   % Magneta lines
    12, 6;   % Cyan lines
    7, 1;   % Red lines
    8, 2;   % Red lines
    1, 2;   % Red lines
    7, 8    % Red lines
    ];

   % Define the colors for each set of connections
   colors = [
    "r"; % Red
    "r"; % Red
    "g"; % Green
    "g"; % Green
    "k"; % Black
    "k"; % Black
    "m"; % Pink
    "m"; % Pink
    "b"; % Blue
    "y"; % Yellow
    "m"; % Magneta
    "c"; % Cyan
    "r"; % Pink
    "r"; % Pink
    "r"; % Blue
    "r"  % Blue
    ];

% Plot the lines between the points with the specified colors
for i = 1:size(connections, 1)
    A = connections(i, 1);
    B = connections(i, 2);
    plot([vertex(A, 1), vertex(B, 1)], [vertex(A, 2), vertex(B, 2)], 'Color', colors(i), 'LineWidth', 2);
end

hold off;
